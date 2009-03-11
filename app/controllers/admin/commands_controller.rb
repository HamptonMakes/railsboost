class Admin::CommandsController < ApplicationController
  before_filter :ip_check
  layout 'admin'
  
  make_resourceful do
    build :all
    
    response_for :index do |format|
      format.html
      format.yaml do
        @commands.collect! do |command|
          command.attributes
        end
        render :text => @commands.to_yaml
      end
    end
    
    response_for :create, :update, :destroy do
      redirect_to admin_commands_path
    end
  end
  
 private
 
  def ip_check
    if Rails.env != "development"
      logger.debug(request.remote_addr != "11")
    end
  end
 
  def build_object
    @current_object ||= params[:type].constantize.new(params[:command])
  end

end
