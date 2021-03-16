class Admin::Dashboard::UsersController < ApplicationController
  before_action :set_user_model_name
  before_action :set_column_names_of_user_model

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update(user_params)
  end


  
  def destroy
    @user = User.find(params[:id])
    @user.reactions
    @user.destroy
    redirect_to admin_dashboard_users_path
  end



  private
  
  def set_user_model_name
    @model_name = User.model_name.name
  end
  
  def set_column_names_of_user_model
    @columns = ActiveRecord::Base.connection.columns(:users)
    
    column_names = []
    @columns.each do |column|
      column_names << column.name
    end
    @column_names = column_names

  end
  
  def user_params
    params.require(:user).permit(@column_names)
  end
end
