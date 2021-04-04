class DemoAdmin::DashboardController < DemoAdmin::ApplicationController
  layout 'demo_admin/dashboard/application.html.erb'
  
  before_action :demo_admin_user

  private

  def demo_admin_user
    redirect_to(root_path) if  current_user.nil? || (!current_user.demo_admin? && !current_user.general?)
  end
end
