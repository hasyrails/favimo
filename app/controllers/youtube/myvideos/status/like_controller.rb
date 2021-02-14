class Youtube::Myvideos::Status::LikeController < ApplicationController
  def index
    @like_myvideos = []
    like_state_records = current_user.favorites.where(status: 'like')
    like_state_records.each do |like_state_record|
      like_state_record_id = like_state_record.youtube_video_id
      like_myvideo = YoutubeVideo.find(like_state_record_id)
      @like_myvideos << like_myvideo
    end
  end
end
