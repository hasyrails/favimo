class DemoAdmin::Dashboard::UsersController < DemoAdmin::DashboardController
  layout 'demo_admin/dashboard/application.html.erb'

  before_action :demo_admin_user
  before_action :set_user_model_name
  before_action :set_column_names_of_user_model
  before_action :set_update_attributes_names_of_user_model

  def index
    @users = User.dammy
    # dammy_users のenumフラグ

    @users = @users.page(params[:page]).per(5)

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

  def new
    if User.all.present?
      users = User.all
      @new_user_id = users.last.id+1
    else
      @new_user_id = 1
    end

    serial_num_for_new_dammy_user = User.last.id + 1
    
    @user = User.dammy.new(
      name: "testuser#{serial_num_for_new_dammy_user}",
      email: "testuser#{serial_num_for_new_dammy_user}@mail.com",
      self_introduction: "testuser#{serial_num_for_new_dammy_user}です",
      password: "test-password",
      
    )
    
    column_names = []
    @columns.each do |column|
      column_names << column.name
    end
    
    column_names.reject! do |column_name| 
      column_name == "id" ||
      column_name == "updated_at" || column_name == "created_at"
    end
    
    @column_names_for_new_user = column_names
  end
  
  def create
    begin
      serial_num_for_new_dammy_user = User.all.size + 1
      @user = User.dammy.create(
        name: "testuser#{serial_num_for_new_dammy_user}",
        email: "testuser#{serial_num_for_new_dammy_user}@mail.com",
        self_introduction: "testuser#{serial_num_for_new_dammy_user}です",
        password: "test-password",
      )
      youtube_video_for_new_dammy_user = YoutubeVideo.dammy.create!(
        user_id: @user.id
      )
      share_video_for_new_dammy_user = @user.share_videos.create!(
        to_user_id: @user.id,
        from_user_id: User.dammy.ids.sample,
        youtube_video_id: YoutubeVideo.dammy.ids.sample
      )
      favorite_for_new_dammy_user = @user.favorites.create!(
        youtube_video_id: YoutubeVideo.dammy.ids.sample
      )
      reaction_for_new_dammy_user = @user.reactions.create!(
        to_user_id: @user.id,
        from_user_id: User.dammy.ids.sample,
        status: "like"
      )
      chat_room_for_new_dammy_user = ChatRoom.dammy.create!
      chat_room_user_as_new_dammy_user = ChatRoomUser.create!(
        chat_room_id: chat_room_for_new_dammy_user.id,
        user_id: @user.id,
      )
      chat_room_user_for_new_dammy_user = ChatRoomUser.create!(
        chat_room_id: chat_room_for_new_dammy_user.id,
        user_id: User.dammy.ids.sample,
      )
      chat_message_for_new_dammy_user = ChatMessage.create!(
        chat_room_id: chat_room_for_new_dammy_user.id,
        user_id: [@user.id, User.dammy.ids].flatten.sample,
        content: ["テストです", "こんにちは", "元気ですか"].sample 
      )

      redirect_to demo_admin_dashboard_users_path
    rescue ActiveRecord::RecordInvalid => e
      @user = e.record
      p e.message
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    @user.reactions
    @user.destroy
    redirect_to demo_admin_dashboard_users_path
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
  
  def set_update_attributes_names_of_user_model
    @columns = ActiveRecord::Base.connection.columns(:users)
    
    column_names = []
    @columns.each do |column|
      column_names << column.name
    end
    column_names.shift
    column_names.pop
    @update_attributes = column_names

  end
  
  def user_params
    params.require(:user).permit(@column_names)
  end


  def demo_admin_user
    redirect_to(root_path) if  current_user.nil? || !current_user.demo_admin?
  end

end
