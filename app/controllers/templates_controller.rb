Mime::Type.register "text", :rb

class TemplatesController < ApplicationController
  make_resourceful do
    build :all, :except => [:delete, :update, :edit]
    
    # Standard response block
    response_for :show do |format|
      format.html
      format.rb { render :text => @rails_template.to_ruby }
    end
  end
  
 private
 
  # Override the default instance variable name, 
  # because Rails uses @template apparently...
  def instance_variable_name
    "rails_templates"
  end
end
