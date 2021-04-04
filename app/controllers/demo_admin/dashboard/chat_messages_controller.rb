class DemoAdmin::Dashboard::ChatMessagesController < DemoAdmin::DashboardController
  layout 'demo_admin/dashboard/application.html.erb'

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
    begin
      @chat_message.update(chat_message_params)
      flash[:notice] = "#{@chat_message.model_name.name}モデルレコードを更新しました<br>id=#{@chat_message.id}"
      redirect_to demo_admin_dashboard_chat_message_path(@chat_message)
    rescue => e
      flash[:alert] = "#{@chat_message.model_name.name}モデルレコードを更新できませんでした"
      render :edit
    end
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
      if @chat_message.save!
        flash[:notice] = "#{@chat_message.model_name.name}モデルレコードを作成しました<br>id=#{@chat_message.id}"
        redirect_to demo_admin_dashboard_chat_messages_path
      else
        flash.now[:alert] = "#{@chat_message.model_name.name}モデルレコードを作成できませんでした"
      end
    rescue ActiveRecord::RecordInvalid => e
      @chat_message = e.record
      p e.message
    end
  end

  
  def destroy
    @chat_message = ChatMessage.find(params[:id])
    if @chat_message.destroy
      flash[:notice] = "#{@chat_message.model_name.name}モデルレコードを削除しました<br>id = #{@chat_message.id}"
      redirect_to demo_admin_dashboard_chat_messages_path
    else
      flash.now[:alert] = "#{@chat_message.model_name.name}モデルレコードを削除できませんでした"
      render :index
    end
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

end
