class Admin::DashboardController < ApplicationController
  before_action :admin_user

  private

  def admin_user
    redirect_to(root_path) if  current_user.nil? || !current_user.admin?
  end
end
