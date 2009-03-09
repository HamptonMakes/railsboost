class UserSessionsController < ApplicationController
  before_filter :require_user, :only => :destroy
  
  make_resourceful do
    
    build :new, :create
    
    before :new do
      @user_session = UserSession.new
    end
    
    after :create do 
      redirect_to admin_commands_path
    end
            
  end
  
  def destroy
    current_user_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_to root_path
  end
  
  
end
