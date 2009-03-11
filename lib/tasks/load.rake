
namespace :commands do 
  desc "Update/Load commands from the remote server"
  task :load  => :environment do
    require 'open-uri'
    yaml = open("http://www.railsboost.com/admin/commands.yaml").read
    YAML.load(yaml).each do |command_attr|
      command = Command.find_by_name(command_attr['name']) || Command.new
      command_attr.delete("id")
      command.attributes = command_attr
      command.type = command_attr["type"]
      command.save
    end
  end
end