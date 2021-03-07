class Youtube::Myvideos::Status::Like::SharedVideosController < ApplicationController
  def index
    shared_states_ids_to_current_user = ShareVideo.where(to_user_id: current_user).map(&:id)

    sharing_users = []

    shared_states_ids_to_current_user.each do |shared_state_id|
      sharing_user_id = ShareVideo.find(shared_state_id).from_user_id
      sharing_user = User.find(sharing_user_id)
      sharing_users << sharing_user
    end
    
    @sharing_users = sharing_users.reverse
    @sharing_users = Kaminari.paginate_array(@sharing_users).page(params[:page]).per(3)
    
    shared_youtube_videos = []
    shared_states_ids_to_current_user.each do |shared_state_id|
      sharing_youtube_video_id = ShareVideo.find(shared_state_id).youtube_video_id
      shared_youtube_video = YoutubeVideo.find(sharing_youtube_video_id)
      shared_youtube_videos << shared_youtube_video
    end
    
    @shared_youtube_videos = shared_youtube_videos.reverse
    
    shared_dates = []
    shared_states_ids_to_current_user.each do |shared_state_id|
      shared_date = ShareVideo.find(shared_state_id).created_at
      shared_dates << shared_date
    end
    
    @shared_dates = shared_dates.reverse

    # shared_youtube_videos = YoutubeVideo.find(shared_youtube_video_ids)

    # binding.pry

  end

end
