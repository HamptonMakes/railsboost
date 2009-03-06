module TemplatesHelper
  
  def initialize_highlighter
      # open = "<script src='/javascripts/"
      # close = ".js' type='text/javascript'></script>"
      # css_open = "<link href='/stylesheets/syntax/"
      # css_close = ".css' media='screen' rel='stylesheet' 'type=text/css' />"
      # puts "#{open}shCore#{close}"
      # puts "#{open}shBrushRuby#{close}"
      # puts "#{css_open}shCore#{css_close}"
      # puts "#{css_open}shThemeDefault#{css_close}"
      puts "<script type='text/javascript'>SyntaxHighlighter.all;</script>"
  end
  
  def code_block(code)
    haml_tag :pre, :class => "brush: ruby; light: true;"  do
      puts preserve("\n" + code)
    end
  end
  
  def check_box_for(name_or_command)
    
    # Pass in either a Command or a string of its name
    if name_or_command.is_a?(String)
      command = Command.find_by_name(name_or_command)
    else
      command = name_or_command
    end
    
    # Build the checkbox for this particular one
    haml_tag :div, :class => "command #{command.command_name}" do
      puts check_box_tag("template[command_ids][]", command.id, false, :command_id => command.id, :id => nil)
      haml_tag :label, "#{command.name} #{command.command_name}"
      
      if command.required_commands.any?
        haml_tag :div, :class => "requirements", :id => "required_commands_#{command.id}" do
          command.required_commands.each do |required_command|
            check_box_for(required_command)
          end
        end
      end
    end
    
    nil
  end
end
