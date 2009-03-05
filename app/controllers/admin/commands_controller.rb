class Admin::CommandsController < ApplicationController
  layout 'admin'
  
  make_resourceful do
    build :all
    
    before :index do
      @commands = Command.find(:all)
    end
    
  end

end
