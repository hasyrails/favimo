class Youtube::Myvideos::Status::LikeController < ApplicationController

  def index
    @like_myvideos = []
    keyword = params[:keyword]
    if keyword.present?
      like_state_records = YoutubeVideo.where(user_id: current_user.id).where(status: 'like').where("title LIKE ?", "%#{keyword}%")
      like_state_records.each do |like_state_record|
        like_state_record_unique_id = like_state_record.video_id
        like_myvideo = YoutubeVideo.find_by(video_id: like_state_record_unique_id)
        @like_myvideos << like_myvideo
      end

    else
      like_state_records = current_user.favorites.where(status: 'like')
      like_state_records.each do |like_state_record|
        like_state_record_id = like_state_record.youtube_video_id
        like_myvideo = YoutubeVideo.find(like_state_record_id)
        @like_myvideos << like_myvideo
      end
    end
    @like_myvideos = Kaminari.paginate_array(@like_myvideos).page(params[:page]).per(3)
  end

  def destroy
    like_myvideo = YoutubeVideo.find(params[:id])
    if like_myvideo.user_id == current_user.id
      like_myvideo.destroy
      like_myvideo.favorites.destroy
      redirect_to youtube_myvideos_status_like_index_path
    end
  end
end
