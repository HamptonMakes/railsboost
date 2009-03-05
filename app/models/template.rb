class Template < ActiveRecord::Base
  has_many :template_commands
  has_many :commands, :through => :template_commands
  serialize :global_options, Hash
  
  def to_ruby
    result = ["# Created by RailsBoost.com", "# Generated at #{Time.now}", nil, nil]
    [:plugin, :gem, :rake, :generate].each do |type|
      result << "# #{type} commands"
      commands.find(:all, :conditions => {:type => "#{type.to_s.capitalize}Command"}).each do |command|
        result << command.to_ruby(global_options)
      end
      result << nil
      result << nil
    end
    
    result.join("\n")
  end
  
  
end
