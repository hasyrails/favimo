class Admin::Dashboard::ChatRoomsController < ApplicationController
  layout 'admin/dashboard/application.html.erb'

  before_action :admin_user
  before_action :set_chat_room_model_name
  before_action :set_column_names_of_chat_room_model

  def index
    @chat_rooms = ChatRoom.page(params[:page]).per(5)
  end

  def show
    @chat_room = ChatRoom.find(params[:id])
  end

  def edit
    @chat_room = ChatRoom.find(params[:id])
  end

  def update
    @chat_room = ChatRoom.find(params[:id])
    @chat_room.update(chat_room_params)
  end

  def new
    if ChatRoom.all.present?
      chat_rooms = ChatRoom.all
      @new_chat_room_id = chat_rooms.last.id+1
    else
      @new_chat_room_id = 1
    end

    @chat_room = ChatRoom.new

    column_names = []
    @columns.each do |column|
      column_names << column.name
    end
    
    column_names.reject! do |column_name| 
      column_name == "id" ||
      column_name == "updated_at" || column_name == "created_at"
    end

    @column_names_for_new_chat_room = column_names
  end

  def create
    begin
      @chat_room = ChatRoom.new(chat_room_params)
      @chat_room.save!
      redirect_to admin_dashboard_chat_rooms_path
    rescue ActiveRecord::RecordInvalid => e
      @chat_room = e.record
      p e.message
    end
  end
  
  def destroy
    @chat_room = ChatRoom.find(params[:id])
    @chat_room.destroy
    redirect_to admin_dashboard_chat_rooms_path
  end



  private
  
  def set_chat_room_model_name
    @model_name = ChatRoom.model_name.name
  end
  
  def set_column_names_of_chat_room_model
    @columns = ActiveRecord::Base.connection.columns(:chat_rooms)
    
    column_names = []
    @columns.each do |column|
      column_names << column.name
    end
    @column_names = column_names

  end
  
  def chat_room_params
    params.permit(@column_names)
  end

  def admin_user
    redirect_to(root_path) if  current_user.nil? || !current_user.admin?
  end

end
