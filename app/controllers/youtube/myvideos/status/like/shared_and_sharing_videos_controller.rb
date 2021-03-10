class Youtube::Myvideos::Status::Like::SharedAndSharingVideosController < ApplicationController
  def show
    share_user_id = ChatRoom.find(params[:id]).chat_room_users.where.not(user_id: current_user.id).map(&:user_id).flatten.first

    @share_user = User.find(share_user_id)

    shared_states = ShareVideo.where(to_user_id: current_user.id, from_user_id: @share_user.id)
    
    
    sharing_states = ShareVideo.where(to_user_id: @share_user.id, from_user_id: current_user.id)
    
    shared_and_sharing_states = []
    shared_and_sharing_states << shared_states
    shared_and_sharing_states << sharing_states
    shared_and_sharing_states = shared_and_sharing_states.flatten.sort_by(&:created_at)
    
    shared_and_sharing_videos_ids = []
    shared_and_sharing_videos_ids = shared_and_sharing_states.map(&:youtube_video_id)
    
    shared_and_sharing_videos = []
    shared_and_sharing_videos_ids.each do |shared_and_sharing_video|
      shared_and_sharing_videos << YoutubeVideo.find(shared_and_sharing_video)
    end
    
    @shared_and_sharing_videos = shared_and_sharing_videos.reverse
    @shared_and_sharing_videos = Kaminari.paginate_array(@shared_and_sharing_videos).page(params[:page]).per(3)
    
    shared_and_sharing_states_ids = shared_and_sharing_states.map(&:id)
    
    shared_and_sharing_states_records = ShareVideo.find(shared_and_sharing_states_ids)

    from_user_ids = []
    shared_and_sharing_states_records.each do |state|
      from_user_ids << state.from_user_id
    end

    from_users = []
    from_user_ids.each do |from_user_id|
      from_users << User.find(from_user_id)
    end

    @from_users = from_users.reverse

    shared_and_sharing_dates = []
    shared_and_sharing_states.each do |state|
       shared_and_sharing_dates << state.created_at
    end

    @shared_and_sharing_dates = shared_and_sharing_dates.reverse

  end
end
