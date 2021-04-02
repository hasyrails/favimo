class DemoAdmin::Dashboard::ChatRoomUsersController < DemoAdmin::DashboardController
  layout 'demo_admin/dashboard/application.html.erb'

  before_action :demo_admin_user
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
    begin
      @chat_room_user.update(chat_room_user_params)
      flash[:notice] = "#{@chat_room_user.model_name.name}モデルレコードを更新しました<br>id = #{@chat_room_user.id}"
      redirect_to demo_admin_dashboard_chat_room_user_path(@chat_room_user)
    rescue => e
      flash[:alert] = "#{@chat_room_user.model_name.name}モデルレコードを更新できませんでした"
      redirect_to edit_demo_admin_dashboard_chat_room_user_path(@chat_room_user)
    end
  end

  def new
  if ChatRoomUser.all.present?
      chat_room_users = ChatRoomUser.all
      @new_chat_room_user_id = chat_room_users.last.id+1
    else
      @new_chat_room_user_id = 1
    end

    @chat_room_user = ChatRoomUser.new

    column_names = []
    @columns.each do |column|
      column_names << column.name
    end
    
    column_names.reject! do |column_name| 
      column_name == "id" ||
      column_name == "updated_at" || column_name == "created_at"
    end

    @column_names_for_new_chat_room_user = column_names
  end

  def create
    begin
      @chat_room_user = ChatRoomUser.new(chat_room_user_params)
      if @chat_room_user.save!
        flash[:notice] = "#{@chat_room_user.model_name.name}モデルレコードを作成しました<br>id = #{@chat_room_user.id}"
        redirect_to demo_admin_dashboard_chat_room_users_path
      else
        flash[:alert] = "#{@chat_room_user.model_name.name}モデルレコードを作成できませんでした"
        render :new
      end
    rescue ActiveRecord::RecordInvalid => e
      @chat_room_user = e.record
      p e.message
    end
  end
  
  def destroy
    @chat_room_user = ChatRoomUser.find(params[:id])
    begin @chat_room_user.destroy
      flash[:notice] = "#{@chat_room_user.model_name.name}モデルレコードを削除しました<br>id = #{@chat_room_user.id}"
      redirect_to demo_admin_dashboard_chat_room_users_path
    rescue => e
      flash[:alert] = "#{@chat_room_user.model_name.name}モデルレコードを削除できませんでした"
      render :index
    end
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

  def demo_admin_user
    redirect_to(root_path) if  current_user.nil? || !current_user.demo_admin?
  end

end
