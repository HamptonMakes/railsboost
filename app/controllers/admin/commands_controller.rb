class Admin::CommandsController < ApplicationController
  layout 'admin'
  
  make_resourceful do
    build :all
    
    before :index do
      @commands = Command.find(:all)
    end
    
    before :create, :update do
      if !params[:command_type].blank?
        command_type = params[:command_type] + 'Command'
        @command.type = command_type
        @command.save!
      else
        @command.type = ''
        @command.save!
      end
    end
    
    response_for :create, :update, :destroy do
      redirect_to admin_commands_path
    end
  end

end
