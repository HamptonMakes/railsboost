class Dependency < ActiveRecord::Base
  belongs_to :command
  belongs_to :required_command, :class_name => "Command"
end
