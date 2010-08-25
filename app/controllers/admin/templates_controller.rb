class Admin::TemplatesController < ApplicationController
  layout 'admin'
  before_filter :admin_check, :only => "delete_old"
  
  def index
    @count = Template.count
    @most_recent = Template.find_most_recent
  end
  
  def delete_old
    raise if request.method != :post
    Template.delete_old
    flash[:message] = 'Older templates have been deleted.'
    redirect_to :action => 'index'
  end
end