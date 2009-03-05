#--
# Copyright (c) 2005 Robert Aman
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#++

require 'feed_tools'
require 'feed_tools/helpers/xml_helper'
require 'rexml/document'

module FeedTools
  # Methods for pulling remote data
  module HtmlHelper
    
    TIDY_OPTIONS = [
      :add_xml_decl, :add_xml_space, :alt_text, :assume_xml_procins, :bare,
      :clean, :css_prefix, :decorate_inferred_ul, :doctype,
      :drop_empty_paras, :drop_font_tags, :drop_proprietary_attributes,
      :enclose_block_text, :enclose_text, :escape_cdata, :fix_backslash,
      :fix_bad_comments, :fix_uri, :hide_comments, :hide_endtags,
      :indent_cdata, :input_xml, :join_classes, :join_styles,
      :literal_attributes, :logical_emphasis, :lower_literals, :merge_divs,
      :ncr, :new_blocklevel_tags, :new_empty_tags, :new_inline_tags,
      :new_pre_tags, :numeric_entities, :output_html, :output_xhtml,
      :output_xml, :preserve_entities, :quote_ampersand, :quote_marks,
      :quote_nbsp, :repeated_attributes, :replace_color, :show_body_only,
      :uppercase_attributes, :uppercase_tags, :word_2000,
      :accessibility_check, :show_errors, :show_warnings, :break_before_br,
      :indent, :indent_attributes, :indent_spaces, :markup,
      :punctuation_wrap, :split, :tab_size, :vertical_space, :wrap,
      :wrap_asp, :wrap_attributes, :wrap_jste, :wrap_php,
      :wrap_script_literals, :wrap_sections, :ascii_chars, :char_encoding,
      :input_encoding, :language, :newline, :output_bom, :output_encoding,
      :error_file, :force_output, :gnu_emacs, :gnu_emacs_file, :keep_time,
      :output_file, :quiet, :slide_style, :tidy_mark, :write_back
    ]

    # Escapes all html entities
    def self.escape_entities(html)
      return nil if html.nil?
      escaped_html = CGI.escapeHTML(html)
      escaped_html.gsub!(/'/, "&apos;")
      escaped_html.gsub!(/"/, "&quot;")
      return escaped_html
    end

    # Unescapes all html entities
    def self.unescape_entities(html)
      return nil if html.nil?
      unescaped_html = html
      unescaped_html.gsub!(/&#x26;/, "&amp;")
      unescaped_html.gsub!(/&#38;/, "&amp;")
      substitute_numerical_entities = Proc.new do |s|
        m = $1
        m = "0#{m}" if m[0] == ?x
        [Integer(m)].pack('U*')
       end
      unescaped_html.gsub!(/&#0*((?:\d+)|(?:x[a-f0-9]+));/, &substitute_numerical_entities)
      unescaped_html = CGI.unescapeHTML(unescaped_html)
      unescaped_html.gsub!(/&apos;/, "'")
      unescaped_html.gsub!(/&quot;/, "\"")
      return unescaped_html
    end

    # Removes all html tags from the html formatted text, but leaves
    # escaped entities alone.
    def self.strip_html_tags(html)
      return nil if html.nil?
      stripped_html = html
      stripped_html.gsub!(/<\/?[^>]+>/, "")
      return stripped_html
    end
    
    # Removes all html tags from the html formatted text and removes
    # escaped entities.
    def self.convert_html_to_plain_text(html)
      return nil if html.nil?
      stripped_html = html
      stripped_html = FeedTools::HtmlHelper.strip_html_tags(stripped_html)
      stripped_html = FeedTools::HtmlHelper.unescape_entities(stripped_html)
      stripped_html.gsub!(/&#8216;/, "'")
      stripped_html.gsub!(/&#8217;/, "'")
      stripped_html.gsub!(/&#8220;/, "\"")
      stripped_html.gsub!(/&#8221;/, "\"")
      return stripped_html  
    end
    
    # Returns true if the html tidy module can be used.
    #
    # Obviously, you need the tidy gem installed in order to run with html
    # tidy features turned on.
    #
    # This method does a fairly complicated, and probably unnecessarily
    # desperate search for the libtidy library.  If you want this thing to
    # execute fast, the best thing to do is to set Tidy.path ahead of time.
    # If Tidy.path is set, this method doesn't do much.  If it's not set,
    # it will do it's darnedest to find the libtidy library.  If you set
    # the LIBTIDYPATH environment variable to the libtidy library, it should
    # be able to find it.
    #
    # Once the library is located, this method will run much faster.
    def self.tidy_enabled?
      # This is an override variable to keep tidy from being used even if it
      # is available.
      if FeedTools.configurations[:tidy_enabled] == false
        return false
      end
      if @tidy_enabled.nil? || @tidy_enabled == false
        @tidy_enabled = false
        begin
          require 'tidy'
          if Tidy.path.nil?
            # *Shrug*, just brute force it, I guess.  There's a lot of places
            # this thing might be hiding in, depending on platform and general
            # sanity of the person who installed the thing.  Most of these are
            # probably unlikely, but it's not like checking unlikely locations
            # hurts.  Much.  Especially if you actually find it.
            libtidy_locations = [
              '/usr/local/lib/libtidy.dylib',
              '/opt/local/lib/libtidy.dylib',
              '/usr/lib/libtidy.dylib',
              '/usr/local/lib/tidylib.dylib',
              '/opt/local/lib/tidylib.dylib',
              '/usr/lib/tidylib.dylib',
              '/usr/local/lib/tidy.dylib',
              '/opt/local/lib/tidy.dylib',
              '/usr/lib/tidy.dylib',
              '/usr/local/lib/libtidy.so',
              '/opt/local/lib/libtidy.so',
              '/usr/lib/libtidy.so',
              '/usr/local/lib/tidylib.so',
              '/opt/local/lib/tidylib.so',
              '/usr/lib/tidylib.so',
              '/usr/local/lib/tidy.so',
              '/opt/local/lib/tidy.so',
              '/usr/lib/tidy.so',
              'C:\Program Files\Tidy\tidy.dll',
              'C:\Tidy\tidy.dll',
              'C:\Ruby\bin\tidy.dll',
              'C:\Ruby\tidy.dll',
              '/usr/local/lib',
              '/opt/local/lib',
              '/usr/lib'
            ]
            # We just made this thing up, but if someone sets it, we'll
            # go ahead and check it
            unless ENV['LIBTIDYPATH'].nil?
              libtidy_locations =
                libtidy_locations.reverse.push(ENV['LIBTIDYPATH'])
            end
            for path in libtidy_locations
              if File.exists? path
                if File.ftype(path) == "file" || File.ftype(path) == "link"
                  Tidy.path = path
                  @tidy_enabled = true
                  break
                elsif File.ftype(path) == "directory"
                  # Ok, now perhaps we're getting a bit more desperate
                  lib_paths =
                    `find #{path} -name '*tidy*' | grep '\\.\\(so\\|dylib\\)$'`
                  # If there's more than one, grab the first one and
                  # hope for the best, and if it doesn't work, then blame the
                  # user for not specifying more accurately.
                  tidy_path = lib_paths.split("\n").first
                  unless tidy_path.nil?
                    Tidy.path = tidy_path
                    @tidy_enabled = true
                    break
                  end
                end
              end
            end
            # Still couldn't find it.
            unless @tidy_enabled
              @tidy_enabled = false
            end
          else
            @tidy_enabled = true
          end
        rescue LoadError
          # Tidy not installed, disable features that rely on tidy.
          @tidy_enabled = false
        end
      end
      return @tidy_enabled
    end

    # Tidys up the html
    def self.tidy_html(html, options = {})
      return nil if html.nil?
      FeedTools::GenericHelper.validate_options(TIDY_OPTIONS, options.keys)

      options = {
        :add_xml_decl => false,
        :char_encoding => "utf8",
        :doctype => "omit",
        :indent => false,
        :logical_emphasis => true,
        :markup => true,
        :show_warnings => false,
        :wrap => 0
      }.merge(options)

      if FeedTools::HtmlHelper.tidy_enabled?
        is_fragment = true
        html.gsub!(/&lt;!'/, "&amp;lt;!'")
        if (html.strip =~ /<html>(.|\n)*<body>/) != nil ||
            (html.strip =~ /<\/body>(.|\n)*<\/html>$/) != nil
          is_fragment = false
        end
        if (html.strip =~ /<\?xml(.|\n)*\?>/) != nil
          is_fragment = false
        end

        options[:show_body_only] = true if is_fragment

        # Tidy sucks?
        # TODO: find the correct set of tidy options to set so
        # that *ugly* hacks like this aren't necessary.
        html = html.gsub(/\302\240/, "\240")

        tidy_html = Tidy.open(options) do |tidy|       
          xml = tidy.clean(html)
          xml
        end
        tidy_html.strip!
      else
        tidy_html = html
      end
      
      if tidy_html.blank? && !html.blank?
        tidy_html = html.strip
      end
      
      return tidy_html
    end

    # Indents a text selection by a specified number of spaces.
    def self.indent(text, spaces)
      lines = text.split("\n")
      buffer = ""
      for line in lines
        line = " " * spaces + line
        buffer << line << "\n"
      end
      return buffer
    end

    # Unindents a text selection by a specified number of spaces.
    def self.unindent(text, spaces)
      lines = text.split("\n")
      buffer = ""
      for line in lines
        for index in 0...spaces
          if line[0...1] == " "
            line = line[1..-1]
          else
            break
          end
        end
        buffer << line << "\n"
      end
      return buffer
    end

    # Returns true if the type string provided indicates that something is
    # xml or xhtml content.
    def self.xml_type?(type)
      if [
        "xml",
        "xhtml",
        "application/xhtml+xml"
      ].include?(type)
        return true
      elsif type != nil && type[-3..-1] == "xml"
        return true
      else
        return false
      end
    end

    # Returns true if the type string provided indicates that something is
    # html or xhtml content.
    def self.text_type?(type)
      return [
        "text",
        "text/plain"
      ].include?(type)
    end
    
    # Returns true if the type string provided indicates that something is
    # html or xhtml content.
    def self.html_type?(type)
      return [
        "html",
        "xhtml",
        "text/html",
        "application/xhtml+xml"
      ].include?(type)
    end

    # Returns true if the type string provided indicates that something is
    # only html (not xhtml) content.
    def self.only_html_type?(type)
      return [
        "html",
        "text/html"
      ].include?(type)
    end
    
    # Resolves all relative uris in a block of html.
    def self.resolve_relative_uris(html, base_uri_sources=[])
      relative_uri_attributes = [
        ["a", "href"],
        ["applet", "codebase"],
        ["area", "href"],
        ["blockquote", "cite"],
        ["body", "background"],
        ["del", "cite"],
        ["form", "action"],
        ["frame", "longdesc"],
        ["frame", "src"],
        ["iframe", "longdesc"],
        ["iframe", "src"],
        ["head", "profile"],
        ["img", "longdesc"],
        ["img", "src"],
        ["img", "usemap"],
        ["input", "src"],
        ["input", "usemap"],
        ["ins", "cite"],
        ["link", "href"],
        ["object", "classid"],
        ["object", "codebase"],
        ["object", "data"],
        ["object", "usemap"],
        ["q", "cite"],
        ["script", "src"]
      ]
      
      # HACK: Prevent the parser from freaking out if it sees this:
      html.gsub!(/<!'/, "&lt;!'")
      
      if FeedTools.configurations[:sanitization_enabled]
        fragments = HTML5::HTMLParser.parse_fragment(
          html, :tokenizer => HTML5::HTMLSanitizer, :encoding => 'UTF-8')
      else
        fragments = HTML5::HTMLParser.parse_fragment(html)
      end
      resolve_node = lambda do |html_node|
        if html_node.kind_of? REXML::Element
          for element_name, attribute_name in relative_uri_attributes
            if html_node.name.downcase == element_name
              attribute = html_node.attribute(attribute_name)
              if attribute != nil
                href = attribute.value
                href = FeedTools::UriHelper.resolve_relative_uri(
                  href, [html_node.base_uri] | base_uri_sources)
                href = FeedTools::UriHelper.normalize_url(href)
                html_node.attribute(attribute_name).instance_variable_set(
                  "@value", href)
                html_node.attribute(attribute_name).instance_variable_set(
                  "@unnormalized", href)
                html_node.attribute(attribute_name).instance_variable_set(
                  "@normalized", href)
                if html_node.attribute(attribute_name).value != href
                  warn("Failed to update href to resolved value.")
                end
              end
            end
          end
        end
        if html_node.respond_to? :children
          for child in html_node.children
            resolve_node.call(child)
          end
        end
        html_node
      end
      fragments.each do |fragment|
        resolve_node.call(fragment)
      end
      html = (fragments.map do |stuff|
        stuff.to_s
      end).join("")
      return html
    end
    
    # Returns a string containing normalized xhtml from within a REXML node.
    def self.extract_xhtml(rexml_node)
      rexml_node_dup = rexml_node.deep_clone
      namespace_hash = FEED_TOOLS_NAMESPACES.dup
      normalize_namespaced_xhtml = lambda do |node, node_dup|
        if node.kind_of? REXML::Element
          node_namespace = node.namespace
          if node_namespace != namespace_hash['atom10'] &&
              node_namespace != namespace_hash['atom03']
            # Massive hack, relies on REXML not changing
            for index in 0...node.attributes.values.size
              attribute = node.attributes.values[index]
              attribute_dup = node_dup.attributes.values[index]
              if attribute.namespace == namespace_hash['xhtml']
                attribute_dup.instance_variable_set(
                  "@expanded_name", attribute.name)
              end
              if node_namespace == namespace_hash['xhtml']
                if attribute.name == 'xmlns'
                  node_dup.attributes.delete('xmlns')
                end
              end
            end
            if node_namespace == namespace_hash['xhtml']
              node_dup.instance_variable_set("@expanded_name", node.name)
            end
            if !node_namespace.blank? && node.prefix.blank?
              if node_namespace != namespace_hash['xhtml']
                prefix = nil
                for known_prefix in namespace_hash.keys
                  if namespace_hash[known_prefix] == node_namespace
                    prefix = known_prefix
                  end
                end
                if prefix.nil?
                  prefix = "unknown" +
                    Digest::SHA1.new(node_namespace).to_s[0..4]
                  namespace_hash[prefix] = node_namespace
                end
                node_dup.instance_variable_set("@expanded_name",
                  "#{prefix}:#{node.name}")
                node_dup.instance_variable_set("@prefix",
                  prefix)
                node_dup.add_namespace(prefix, node_namespace)
              end
            end
          end
        end
        for index in 0...node.children.size
          child = node.children[index]
          if child.kind_of? REXML::Element
            child_dup = node_dup.children[index]
            normalize_namespaced_xhtml.call(child, child_dup)
          end
        end
      end
      normalize_namespaced_xhtml.call(rexml_node, rexml_node_dup)
      buffer = ""
      rexml_node_dup.each_child do |child|
        if child.kind_of? REXML::Comment
          buffer << "<!--" + child.to_s + "-->"
        else
          buffer << child.to_s
        end
      end
      return buffer.strip
    end
    
    # Given a REXML node, returns its content, normalized as HTML.
    def self.process_text_construct(content_node, feed_type, feed_version,
        base_uri_sources=[])
      if content_node.nil?
        return nil
      end
      
      content = nil
      root_node_name = nil
      type = FeedTools::XmlHelper.try_xpaths(content_node, "@type",
        :select_result_value => true)
      mode = FeedTools::XmlHelper.try_xpaths(content_node, "@mode",
        :select_result_value => true)
      encoding = FeedTools::XmlHelper.try_xpaths(content_node, "@encoding",
        :select_result_value => true)

      if type.nil?
        atom_namespaces = [
          FEED_TOOLS_NAMESPACES['atom10'],
          FEED_TOOLS_NAMESPACES['atom03']
        ]
        if ((atom_namespaces.include?(content_node.namespace) ||
            atom_namespaces.include?(content_node.root.namespace)) ||
            feed_type == "atom")
          type = "text"
        end
      end
        
      # Note that we're checking for misuse of type, mode and encoding here
      if content_node.cdatas.size > 0
        content = content_node.cdatas.first.to_s.strip
      elsif type == "base64" || mode == "base64" ||
          encoding == "base64"
        content = Base64.decode64(content_node.inner_xml.strip)
      elsif type == "xhtml" || mode == "xhtml" ||
          type == "xml" || mode == "xml" ||
          type == "application/xhtml+xml" ||
          content_node.namespace == FEED_TOOLS_NAMESPACES['xhtml']
        content = FeedTools::HtmlHelper.extract_xhtml(content_node)
      elsif type == "escaped" || mode == "escaped" ||
          type == "html" || mode == "html" ||
          type == "text/html" || mode == "text/html"
        content = FeedTools::HtmlHelper.unescape_entities(
          content_node.inner_xml.strip)
      elsif type == "text" || mode == "text" ||
          type == "text/plain" || mode == "text/plain"
        content = FeedTools::HtmlHelper.unescape_entities(
          content_node.inner_xml.strip)
      else
        content = FeedTools::HtmlHelper.unescape_entities(
          content_node.inner_xml.strip)
      end
      if type == "text" || mode == "text" ||
          type == "text/plain" || mode == "text/plain"
        content = FeedTools::HtmlHelper.escape_entities(content)
      end        
      unless content.nil?
        content = FeedTools::HtmlHelper.resolve_relative_uris(content,
          [content_node.base_uri] | base_uri_sources)
        content = FeedTools::HtmlHelper.tidy_html(content)
      end
      if FeedTools.configurations[:tab_spaces] != nil
        spaces = FeedTools.configurations[:tab_spaces].to_i
        content.gsub!("\t", " " * spaces) unless content.blank?
      end
      content.strip unless content.blank?
      content = nil if content.blank?
      return content
    end

    # Strips semantically empty div wrapper elements
    def self.strip_wrapper_element(xhtml)
      return nil if xhtml.nil?
      return xhtml if xhtml.blank?
      begin
        doc = REXML::Document.new(xhtml.to_s.strip)
        if doc.children.size == 1
          child = doc.children[0]
          if child.kind_of?(REXML::Element) && child.name.downcase == "div"
            return child.inner_xml.strip
          end
        end
        return xhtml.to_s.strip
      rescue Exception
        return xhtml.to_s.strip
      end
    end
    
    # Given a block of html, locates feed links with a given mime type.
    def self.extract_link_by_mime_type(html, mime_type)
      require 'feed_tools/helpers/xml_helper'
      
      # HACK: Prevent the parser from freaking out if it sees this:
      html = html.gsub(/<!'/, "&lt;!'")

      # This is technically very, very wrong.  But it saves oodles of
      # clock cycles, and probably works 99.999% of the time.
      html.gsub!(/<body.*?>(.|\n)*?<\/body>/, "<body></body>")
      html.gsub!(/<script.*?>(.|\n)*?<\/script>/, "")
      html.gsub!(/<noscript.*?>(.|\n)*?<\/noscript>/, "")
      html.gsub!(/<!--(.|\n)*?-->/, "")
      
      html = FeedTools::HtmlHelper.tidy_html(html)
      
      document = HTML5::HTMLParser.parse(html)

      link_nodes = []
      get_link_nodes = lambda do |root_node|
        html_node = nil
        head_node = nil
        return nil if !root_node.respond_to?(:children)
        if root_node.name.downcase == "html" &&
            root_node.children.size > 0
          html_node = root_node
        else
          for node in fragment_node.children
            next unless node.kind_of?(REXML::Element)
            if node.name.downcase == "html" &&
                node.children.size > 0
              html_node = node
              break
            end
          end
        end
        if html_node != nil
          for node in html_node.children
            next unless node.kind_of?(REXML::Element)
            if node.name.downcase == "head"
              head_node = node
              break
            end
            if node.name.downcase == "link"
              link_nodes << node
            end
          end
          if html_node != nil || !link_nodes.empty?
            if head_node != nil
              link_nodes = []
              for node in head_node.children
                next unless node.kind_of?(REXML::Element)
                if node.name.downcase == "link"
                  link_nodes << node
                end
              end
            end
          end
        end
      end
      get_link_nodes.call(document.root)
      process_link_nodes = lambda do |links|
        for link in links
          next unless link.kind_of?(REXML::Element)
          if link.attributes['type'].to_s.strip.downcase ==
              mime_type.downcase &&
              link.attributes['rel'].to_s.strip.downcase == "alternate"
            href = link.attributes['href']
            return href unless href.blank?
          end
        end
        for link in links
          next unless link.kind_of?(REXML::Element)
          process_link_nodes.call(link.children)
        end
      end
      process_link_nodes.call(link_nodes)
      return nil
    end
  end
end
