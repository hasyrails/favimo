class DemoAdmin::Dashboard::YoutubeVideosController < DemoAdmin::DashboardController
  layout 'demo_admin/dashboard/application.html.erb'

  before_action :demo_admin_user
  before_action :set_youtube_video_model_name
  before_action :set_column_names_of_youtube_video_model

  def index
    @youtube_videos = YoutubeVideo.dammy.page(params[:page]).per(5)
  end

  def show
    @youtube_video = YoutubeVideo.find(params[:id])
  end

  def edit
    @youtube_video = YoutubeVideo.find(params[:id])
  end

  def update
    @youtube_video = YoutubeVideo.find(params[:id])
    if @youtube_video.update(youtube_video_params)
      redirect_to demo_admin_dashboard_youtube_videos_path(@youtube_video)
    else
      render :edit
    end
  end

  def new
    if YoutubeVideo.all.present?
      youtube_videos = YoutubeVideo.all
      @new_youtube_video_id = youtube_videos.last.id+1
    else
      @new_youtube_video_id = 1
    end

    @youtube_video = YoutubeVideo.new

    column_names = []
    @columns.each do |column|
      column_names << column.name
    end
    
    column_names.reject! do |column_name| 
      column_name == "id" ||
      column_name == "updated_at" || column_name == "created_at"
    end

    @column_names_for_new_youtube_video = column_names
  end

  def create
    begin
      @youtube_video = YoutubeVideo.new(youtube_video_params)
      @youtube_video.save!
      redirect_to demo_admin_dashboard_youtube_videos_path
    rescue ActiveRecord::RecordInvalid => e
      @youtube_video = e.record
      p e.message
    end
  end

  
  def destroy
    @youtube_video = YoutubeVideo.find(params[:id])
    @youtube_video.destroy
    redirect_to demo_admin_dashboard_youtube_videos_path
  end



  private
  
  def set_youtube_video_model_name
    @model_name = YoutubeVideo.model_name.name
  end
  
  def set_column_names_of_youtube_video_model
    @columns = ActiveRecord::Base.connection.columns(:youtube_videos)
    
    column_names = []
    @columns.each do |column|
      column_names << column.name
    end
    @column_names = column_names

  end
  
  def youtube_video_params
    @column_names.delete("status")
    @column_names
    params.require(:youtube_video).permit(@column_names)
  end

  def demo_admin_user
    redirect_to(root_path) if  current_user.nil? || !current_user.demo_admin?
  end

end
