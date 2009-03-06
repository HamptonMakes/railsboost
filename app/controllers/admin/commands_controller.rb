class Admin::CommandsController < ApplicationController
  layout 'admin'
  
  make_resourceful do
    build :all
    
    response_for :create, :update, :destroy do
      redirect_to admin_commands_path
    end
  end
  
 private
 
  def build_object
    @current_object ||= params[:type].constantize.new(params[:command])
  end

end
