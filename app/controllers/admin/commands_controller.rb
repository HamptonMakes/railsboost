class Admin::CommandsController < ApplicationController
  layout 'admin'
  
  make_resourceful do
    build :all
    
    before :index do
      @commands = Command.find(:all)
    end
    
    response_for :create, :update, :destroy do
      redirect_to admin_commands_path
    end
  end

end
