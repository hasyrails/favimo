class DemoAdmin::TopController < ApplicationController
  before_action :demo_admin_user

  def index
  end

  private

  def demo_admin_user
    redirect_to(root_path) unless current_user.nil? || current_user.demo_admin? 
  end
end
