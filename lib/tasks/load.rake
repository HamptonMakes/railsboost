
namespace :command do 
  desc "Load shit"
  task :load do
    require 'open-uri'
    yaml = open("http://www.railsboost.com/admin/commands.yaml").read
    commands = YAML.load(yaml)
    puts commands.inspect
  end
end