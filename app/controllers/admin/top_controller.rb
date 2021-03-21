class Admin::TopController < ApplicationController
  before_action :admin_user

  def index
  end

  private

  def admin_user
    redirect_to(root_path) unless current_user.nil? || current_user.admin? 
  end
end
