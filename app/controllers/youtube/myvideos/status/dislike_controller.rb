class Youtube::Myvideos::Status::DislikeController < ApplicationController
  before_action :expired_dislike_myvideos_destroy_setting, only: [:index]
  before_action :expired_dislike_myvideos_destroy!, only: [:index]

  def index
    @dislike_myvideos = []
    keyword = params[:keyword]
    if keyword.present?
      dislike_state_records = YoutubeVideo.where(user_id: current_user.id).where(status: 'dislike').where("title LIKE ?", "%#{keyword}%")
      dislike_state_records.each do |dislike_state_record|
        dislike_state_record_unique_id = dislike_state_record.video_id
        dislike_myvideo = YoutubeVideo.find_by(video_id: dislike_state_record_unique_id)
        @dislike_myvideos << dislike_myvideo
      end

    else
      dislike_state_records = current_user.favorites.where(status: 'dislike')
      dislike_state_records.each do |dislike_state_record|
        dislike_state_record_id = dislike_state_record.youtube_video_id
        dislike_myvideo = YoutubeVideo.find(dislike_state_record_id)
        @dislike_myvideos << dislike_myvideo
      end
    end
    @dislike_myvideos = Kaminari.paginate_array(@dislike_myvideos).page(params[:page]).per(3)
  end

  def destroy
    dislike_myvideo = YoutubeVideo.find(params[:id])
    if dislike_myvideo.user_id == current_user.id
      dislike_myvideo.destroy
      dislike_myvideo.favorites.destroy
      redirect_to youtube_myvideos_status_dislike_index_path
    end
  end
  
  
  private
  
  def expired_dislike_myvideos_destroy_setting
    time = Time.now
    dislike_youtube_videos = YoutubeVideo.where(status: 'dislike')
    dislike_youtube_videos.each do |dislike_youtube_video|
      if dislike_youtube_video.is_remaining &&  dislike_youtube_video.updated_at < time.ago(7.days)
        dislike_youtube_video.update(is_remaining: 'not_remaining')
        dislike_youtube_video.save!
      end
    end
  end
  
  def expired_dislike_myvideos_destroy!
    expired_dislike_youtube_videos = YoutubeVideo.where(status: 'dislike', is_remaining: 'not_remaining')
    expired_dislike_youtube_videos.destroy_all
  end
  
end
