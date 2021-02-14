class Youtube::Myvideos::Status::DislikeController < ApplicationController
  def index
    @dislike_myvideos = []
    dislike_state_records = current_user.favorites.where(status: 'dislike')
    dislike_state_records.each do |dislike_state_record|
      dislike_state_record_id = dislike_state_record.youtube_video_id
      dislike_myvideo = YoutubeVideo.find(dislike_state_record_id)
      @dislike_myvideos << dislike_myvideo
    end
  end
end
