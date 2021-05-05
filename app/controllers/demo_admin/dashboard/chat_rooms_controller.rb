class DemoAdmin::Dashboard::ChatRoomsController < DemoAdmin::DashboardController
  layout 'demo_admin/dashboard/application.html.erb'

  before_action :set_chat_room_model_name
  before_action :set_column_names_of_chat_room_model

  def index
    @chat_rooms = ChatRoom.dummy
    @chat_rooms = @chat_rooms.page(params[:page]).per(5)
  end

  def show
    @chat_room = ChatRoom.find(params[:id])
  end

  def edit
    @chat_room = ChatRoom.find(params[:id])
  end

  def update
    @chat_room = ChatRoom.find(params[:id])
    begin
      @chat_room.update(chat_room_params)
      flash[:notice] = "#{@chat_room.model_name.name}モデルレコードを更新しました<br>id=#{@chat_room.model_name.name}"
      redirect_to demo_admin_dashboard_chat_rooms_path
    rescue => e
      p e.message
      flash[:alert] = "#{@chat_room.model_name.name}モデルレコードを更新できませんでした<br>id=#{@chat_room.model_name.name}"
      redirect_to edit_demo_admin_dashboard_chat_room_path(@chat_room)
    end
  end

  def new
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
    if @chat_room = ChatRoom.create!(chat_room_params)
      flash[:notice] = "#{@chat_room.model_name.name}レコードを作成しました<br>id = #{@chat_room.id}"
      redirect_to demo_admin_dashboard_chat_rooms_path
    else
      flash.now[:alert] = "#{@chat_room.model_name.name}レコードを作成できませんでした"
      render :new
    end
  end
  
  def destroy
    @chat_room = ChatRoom.find(params[:id])
    if @chat_room.destroy
      flash[:notice] = "#{@chat_room.model_name.name}レコードを削除しました<br>id = #{@chat_room.id}"
      redirect_to demo_admin_dashboard_chat_rooms_path
    else
      flash.now[:alert] = "#{@chat_room.model_name.name}レコードを作成できませんでした"
      render :index
    end
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
    params.require(:chat_room).permit(@column_names.push(:chat_room))
  end

end
