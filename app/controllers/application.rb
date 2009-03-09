# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  filter_parameter_logging :password, :password_confirmation
  helper_method :current_user_session, :current_user

  private
  
    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.user
    end

  
    def require_user
      if !current_user
        # store_location
        flash[:notice] = "You must be logged in to access this page"
        redirect_to "/login"
        return false
      end
    end


    # def store_location
    #   session[:return_to] = request.request_uri
    # end
    # 
    # def redirect_back_or_default(default)
    #   redirect_to(session[:return_to] || default)
    #   session[:return_to] = nil
    # end
  
end
