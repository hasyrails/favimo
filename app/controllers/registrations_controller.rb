class RegistrationsController < Devise::RegistrationsController
  before_action :ensure_normal_user, only: [:update, :destroy]
  prepend_before_action :require_no_authentication, only: [:cancel]
  
  def create
    super
    bypass_sign_in(@user)
  end

  protected
  
  def update_resource(resource, params)
    resource.update_without_current_password(params)
  end

  def after_update_path_for(resource)
    user_path(resource)
  end

  def after_sign_up_path_for(resource)
    users_path
  end

  def ensure_normal_user
    if resource.email == 'guest@example.com'
      redirect_to root_path, alert: 'ゲストユーザーは変更・削除できません。'
    end
  end

end
