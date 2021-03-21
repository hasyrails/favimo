class Admin::Dashboard::ChatMessagesController < ApplicationController
  layout 'admin/dashboard/application.html.erb'

  before_action :admin_chat_message
  before_action :set_chat_message_model_name
  before_action :set_column_names_of_chat_message_model

  def index
    @chat_messages = ChatMessage.all

    @chat_messages = ChatMessage.page(params[:page]).per(5)

  end

  def show
    @chat_message = ChatMessage.find(params[:id])
  end

  def edit
    @chat_message = ChatMessage.find(params[:id])
  end

  def update
    @chat_message = ChatMessage.find(params[:id])
    @chat_message.update(chat_message_params)
  end

  def new
    if ChatMessage.all.present?
      chat_messages = ChatMessage.all
      @new_chat_message_id = chat_messages.last.id+1
    else
      @new_chat_message_id = 1
    end

    @chat_message = ChatMessage.new

    column_names = []
    @columns.each do |column|
      column_names << column.name
    end
    
    column_names.reject! do |column_name| 
      column_name == "id" ||
      column_name == "updated_at" || column_name == "created_at"
    end

    @column_names_for_new_chat_message = column_names
  end

  def create
    begin
      @chat_message = ChatMessage.new(chat_message_params)
      @chat_message.save!
      redirect_to admin_dashboard_chat_messages_path
    rescue ActiveRecord::RecordInvalid => e
      @chat_message = e.record
      p e.message
    end
  end

  
  def destroy
    @chat_message = ChatMessage.find(params[:id])
    @chat_message.destroy
    redirect_to admin_dashboard_chat_messages_path
  end

  private
  
  def set_chat_message_model_name
    @model_name = ChatMessage.model_name.name
  end
  
  def set_column_names_of_chat_message_model
    @columns = ActiveRecord::Base.connection.columns(:chat_messages)
    
    column_names = []
    @columns.each do |column|
      column_names << column.name
    end
    @column_names = column_names
  end
  
  def chat_message_params
    column_names = []
    @columns.each do |column|
      column_names << column.name
    end
    
    params.require(:chat_message).permit(column_names)
  end

  def admin_chat_message
    redirect_to(root_path) if  current_user.nil? || !current_user.admin?
  end
end
