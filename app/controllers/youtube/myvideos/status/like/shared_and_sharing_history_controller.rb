class Youtube::Myvideos::Status::Like::SharedAndSharingHistoryController < ApplicationController
  def show
    sharing_states_from_current_user = ShareVideo.where(from_user_id: current_user.id)

    shared_states_to_current_user = ShareVideo.where(to_user_id: current_user.id)

    shared_and_sharing_states_related_to_current_user = []

    sharing_states_from_current_user.each do |sharing_state|
      shared_and_sharing_states_related_to_current_user << sharing_state
    end

    shared_states_to_current_user.each do |shared_state|
      shared_and_sharing_states_related_to_current_user << shared_state
    end

    shared_and_sharing_states_related_to_current_user = shared_and_sharing_states_related_to_current_user.sort_by(&:created_at).reverse

    share_dates = []
    shared_and_sharing_states_related_to_current_user.each do |state|
      share_dates << state.created_at
    end

    @share_dates = share_dates

    youtube_video_ids = []
    shared_and_sharing_states_related_to_current_user.each do |state|
      youtube_video_ids << state.youtube_video_id
    end

    videos = []
    youtube_video_ids.each do |youtube_video_id|
      videos << YoutubeVideo.find(youtube_video_id)
    end

    @videos = videos
    @videos = Kaminari.paginate_array(@videos).page(params[:page]).per(3)
    
    from_user_ids = []
    shared_and_sharing_states_related_to_current_user.each do |state|
      from_user_ids << state.from_user_id
    end

    from_users = []
    from_user_ids.each do |from_user_id|
      from_users << User.find(from_user_id)
    end
    @from_users = from_users.reverse
    
    to_user_ids = []
    shared_and_sharing_states_related_to_current_user.each do |state|
      to_user_ids << state.to_user_id
    end
    
    to_users = []
    to_user_ids.each do |to_user_id|
      to_users << User.find(to_user_id)
    end
    @to_users = to_users.reverse
    
    # binding.pry
    
  end

end
