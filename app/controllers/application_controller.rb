# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

private
  # Yes, this is a hack, but its not worth it at this point to write a whole auth system
  def admin_check
    logger.warn request.remote_addr.inspect
    if Rails.env == "production" && !["77.250.47.10", "99.166.163.112"].include?(request.remote_ip)
      render :text => "GETTHEFUCKOUT"
    end
  end
end
