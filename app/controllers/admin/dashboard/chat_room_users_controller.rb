class Admin::Dashboard::ChatRoomUsersController < ApplicationController
  layout 'admin/dashboard/application.html.erb'

  before_action :admin_user
  before_action :set_chat_room_user_model_name
  before_action :set_column_names_of_chat_room_user_model

  def index
    @chat_room_users = ChatRoomUser.page(params[:page]).per(5)
  end

  def show
    @chat_room_user = ChatRoomUser.find(params[:id])
  end

  def edit
    @chat_room_user = ChatRoomUser.find(params[:id])
  end

  def update
    @chat_room_user = ChatRoomUser.find(params[:id])
    @chat_room_user.update(chat_room_user_params)
  end


  
  def destroy
    @chat_room_user = ChatRoomUser.find(params[:id])
    @chat_room_user.destroy
    redirect_to admin_dashboard_chat_room_users_path
  end



  private
  
  def set_chat_room_user_model_name
    @model_name = ChatRoomUser.model_name.name
  end
  
  def set_column_names_of_chat_room_user_model
    @columns = ActiveRecord::Base.connection.columns(:chat_room_users)
    
    column_names = []
    @columns.each do |column|
      column_names << column.name
    end
    @column_names = column_names

  end
  
  def chat_room_user_params
    params.require(:chat_room_user).permit(@column_names)
  end

  def admin_user
    redirect_to(root_path) if  current_user.nil? || !current_user.admin?
  end

end
