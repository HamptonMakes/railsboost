class Template < ActiveRecord::Base
  has_many :template_commands
  has_many :commands, :through => :template_commands
  serialize :global_options, Hash
  
  def to_ruby
    result = ["# Created by RailsBoost.com", "# Generated at #{Time.now}", nil]
    
    
    [:plugin, :gem, :rake, :generate, ""].each do |type|
      class_name = "#{type.to_s.capitalize}Command"
      class_name = nil if class_name == "Command"

      command_group = commands.find(:all, :conditions => {:type => class_name})
      
      if command_group.any?
        result << "############## #{type} commands #################\n"
        command_group.each do |command|
          result << command.to_ruby(global_options)
        end
        result << nil
        result << nil
      end
    end
    
    result.join("\n")
  end
  
end
