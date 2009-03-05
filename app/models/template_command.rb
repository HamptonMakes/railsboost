class TemplateCommand < ActiveRecord::Base
  belongs_to :template
  belongs_to :command
end
