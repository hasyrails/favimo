class Admin::DashboardController < Admin::ApplicationController
  layout 'admin/dashboard/application.html.erb'
  
  before_action :admin_user

  private

  def admin_user
    redirect_to(root_path) if  current_user.nil? || !current_user.admin?
  end
end

