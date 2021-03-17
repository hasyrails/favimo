class Admin::Dashboard::ChatMessagesController < ApplicationController
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
    params.require(:chat_message).permit(@column_names)
  end


  def admin_chat_message
    redirect_to(root_path) if  current_user.nil? || !current_user.admin?
  end

end
