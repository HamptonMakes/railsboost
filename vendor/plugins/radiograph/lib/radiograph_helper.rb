# Module that is mixed into ActionView::Base to
# expose Ultraviolet (http://ultraviolet.rubyforge.org/)
# to your views.
module RadiographHelper
  # Method that calls Radiograph.code (which in turn calls
  # <tt>Uv.parse</tt>).
  #
  # ==== Options
  # theme:: Set the theme you would like to use for this code block.
  #         It defaults to 'all_hallows_eve' or the value you set in
  #         environment.rb.
  #
  # syntax:: Set the syntax used in this code block.  The default value
  #          is 'ruby' or the value you specified in environment.rb.
  #
  # line_numbers:: Toggle line numbers on the output (defaults to +true+ or
  #                the value you specify in environment.rb).
  #
  # ==== Examples
  # code("require 'uv'\n\nUv.is_cool?  # => true")
  # # => <pre class="all_hallows_eve"><span class="line-numbers"> 1 </span> <span class="Keyword">require</span> [...] </pre>
  #
  # # The code method is also aliased as c()
  # c("my_value ? puts 'Good!' : puts 'Oh noez!'", :theme => 'amy')
  # # => <pre class="all_hallows_eve"><span class="line-numbers"> 1 </span> my_value [...] </pre>
  #
  # code("show_menu if current_user", :theme => 'dawn', :syntax => 'ruby_on_rails', :line_numbers => false)
  # # => <pre class="dawn"><span class="line-numbers">   1 </span> show_menu <span class="Keyword">if</span> current_user </pre>
  #
  def code(code, opts={})
    Radiograph.code(code, opts)
  end
  
  # Method that will link a stylesheet for syntax highlighting.  If no theme name is given in the +theme+ argument, then 
  # it will link the stylesheet for the default (<tt>all_hallows_eve</tt>) or the theme you specified in environment.rb. 
  def require_syntax_stylesheet(theme=nil)
    stylesheet_link_tag "syntax/#{theme || Radiograph.theme}.css"
  end
  
  # Convenience aliases
  
  alias :syntax_css :require_syntax_stylesheet
  alias :require_syntax_css :require_syntax_stylesheet
  alias :c :code
end