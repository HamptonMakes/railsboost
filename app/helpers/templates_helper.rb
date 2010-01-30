module TemplatesHelper
  
  def initialize_highlighter
      haml_tag :script, :type => 'text/javascript' do
        puts "SyntaxHighlighter.all();"
      end
  end
  
  def code_block(code)
    haml_tag :div, :class => "syndiv" do
      haml_tag :pre, :class => "brush: ruby; light: true;"  do
        puts preserve("\n" + code)
      end
    end
  end
  
  def check_box_for(name_or_command, options = {})
    
    # Pass in either a Command or a string of its name
    if name_or_command.is_a?(String)
      command = Command.find_by_name(name_or_command)
    else
      command = name_or_command
    end
    
    # Build the checkbox for this particular one
    haml_tag :div, :class => "command #{command.category}" do
      haml_tag :label do
        puts check_box_tag("template[command_ids][]", command.id, false, :command_id => command.id, :id => nil)
        puts "#{command.name} #{command.category}"
      end
      
      if (command.description || "").any?
        description_id = "description_#{command.id}"
        if options[:suggested]
          #haml_tag :small, "suggested"
        end
        puts link_to("?", "#", :onclick => "$('##{description_id}').slideToggle('fast'); return false;")
        
        haml_tag :div, :class => "description", :id => description_id, :style => "display: none" do
          # Code sample
          haml_tag :pre do
            puts preserve("\n" + command.to_ruby)
          end
          
          if (command.url || "").any?
            haml_tag :div, :class => "more_info" do
              # Link if it exists
              puts link_to("Home Page", command.url, :target => "_blank") 
            end
          end
        end
      end
      
      if command.required_commands.any?
        haml_tag :div, :class => "requirements", :id => "required_commands_#{command.id}" do
          command.required_commands.each do |required_command|
            check_box_for(required_command, :suggested => true)
          end
        end
      end
    end
    
    nil
  end
end
