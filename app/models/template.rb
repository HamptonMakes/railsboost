class Template < ActiveRecord::Base
  has_many :template_commands, :dependent => :delete_all
  has_many :commands, :through => :template_commands
  serialize :global_options, Hash

  def self.find_most_recent
    find(:first, :order => 'created_at DESC')
  end
  
  def self.delete_old
    most_recent = find_most_recent
    if most_recent
      destroy_all(['created_at < ?', most_recent.created_at - 1.day])
    end
  end

  def to_ruby
    result = ["# Created by RailsBoost.com", "# Generated at #{Time.now}", "# Generator by Hampton Catlin", nil]

    [:plugin, :gem, :rake, :generate, ""].each do |type|
      class_name = type.blank? ? nil : "#{type.to_s.capitalize}Command"

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
