class TemplatesController < ApplicationController
  make_resourceful do
    build :all
  end
  
 private
 
  def instance_variable_name
    "rails_templates"
  end
end
