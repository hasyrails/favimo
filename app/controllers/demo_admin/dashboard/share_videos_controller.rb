class DemoAdmin::Dashboard::ShareVideosController < DemoAdmin::DashboardController
  layout 'demo_admin/dashboard/application.html.erb'

  before_action :set_share_video_model_name
  before_action :set_column_names_of_share_video_model

  def index
    @share_videos = ShareVideo.where(youtube_video_id: YoutubeVideo.dummy.ids, to_user_id: User.dummy.ids, from_user_id: User.dummy.ids)
    @share_videos = @share_videos.page(params[:page]).per(5)
  end

  def show
    @share_video = ShareVideo.find(params[:id])
  end

  def edit
    @share_video = ShareVideo.find(params[:id])
  end

  def update
    @share_video = ShareVideo.find(params[:id])
    begin
      @share_video.update(share_video_params)
      flash[:notice] = "#{@share_video.model_name.name}モデルレコードを更新しました<br>id = #{@share_video.id}"
      redirect_to demo_admin_dashboard_share_video_path(@share_video)
    rescue => e
      p e.message
      flash.now[:alert] = "#{@share_video.model_name.name}モデルレコードを更新できませんでした"
      render edit_demo_admin_dashboard_share_video_path(@share_video)
    end
  end

  def new
    if ShareVideo.all.present?
      share_videos = ShareVideo.all
      @new_share_video_id = share_videos.last.id+1
    else
      @new_share_video_id = 1
    end

    @share_video = ShareVideo.new

    column_names = []
    @columns.each do |column|
      column_names << column.name
    end
    
    column_names.reject! do |column_name| 
      column_name == "id" ||
      column_name == "updated_at" || column_name == "created_at"
    end

    @column_names_for_new_share_video = column_names
  end
  
  def create
    begin
      @share_video = ShareVideo.new(share_video_params)
      @share_video.save!
      flash[:notice] = "#{@share_video.model_name.name}モデルレコードを作成しました<br>id = #{@share_video.id}"
      redirect_to demo_admin_dashboard_share_videos_path
    rescue ActiveRecord::RecordInvalid => e
      flash[:alert] = "#{@share_video.model_name.name}モデルレコードを作成できませんでした"
      redirect_to new_demo_admin_dashboard_share_videos_path
    end
  end
  
  def destroy
    @share_video = ShareVideo.find(params[:id])
    begin
      @share_video.destroy
      flash[:notice] = "#{@share_video.model_name.name}モデルレコードを削除しました<br>id = #{@share_video.id}"
      redirect_to demo_admin_dashboard_share_videos_path
    rescue => exception
      flash[:alert] = "#{@share_video.model_name.name}モデルレコードを削除できませんでした"
      redirect_to demo_admin_dashboard_share_videos_path
    end
  end



  private
  
  def set_share_video_model_name
    @model_name = ShareVideo.model_name.name
  end
  
  def set_column_names_of_share_video_model
    @columns = ActiveRecord::Base.connection.columns(:share_videos)
    
    column_names = []
    @columns.each do |column|
      column_names << column.name
    end
    @column_names = column_names

  end
  
  def share_video_params
    params.require(:share_video).permit(@column_names)
  end

end
