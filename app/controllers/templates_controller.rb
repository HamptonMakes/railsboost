Mime::Type.register "text", :rb


class TemplatesController < ApplicationController
  make_resourceful do
    build :all
    
    response_for :show do |format|
      format.html
      format.rb { render :text => @rails_template.to_ruby }
    end
  end
  
 private
 
  def instance_variable_name
    "rails_templates"
  end
end
