class Admin::Dashboard::ShareVideosController < ApplicationController
  layout 'admin/dashboard/application.html.erb'

  before_action :admin_user
  before_action :set_share_video_model_name
  before_action :set_column_names_of_share_video_model

  def index
    @share_videos = ShareVideo.page(params[:page]).per(5)
  end

  def show
    @share_video = ShareVideo.find(params[:id])
  end

  def edit
    @share_video = ShareVideo.find(params[:id])
  end

  def update
    @share_video = ShareVideo.find(params[:id])
    @share_video.update(share_video_params)
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
      redirect_to admin_dashboard_share_videos_path
    rescue ActiveRecord::RecordInvalid => e
      @share_video = e.record
      p e.message
    end
  end
  
  def destroy
    @share_video = ShareVideo.find(params[:id])
    @share_video.destroy
    redirect_to admin_dashboard_share_videos_path
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

  def admin_user
    redirect_to(root_path) if  current_user.nil? || !current_user.admin?
  end

end
