class Users::VideoShareController < ApplicationController
  def new
    @user = User.find(params[:user_id])

    favorite_states_by_current_user = Favorite.where(user_id: current_user.id, status: "like")

    keyword = params[:keyword]
    like_myvideos = []
    
    if keyword.present?
      keyword_match_myvideos = YoutubeVideo.where('title LIKE ?', '%'+keyword+'%')
      keyword_match_myvideos.each do |keyword_match_myvideo|
        like_myvideos << YoutubeVideo.find(keyword_match_myvideo.id)
      end
    else
      favorite_states_by_current_user.each do |favorite_state|
        like_myvideos << YoutubeVideo.find(favorite_state.youtube_video_id)
      end
    end

      
    @like_myvideos = like_myvideos
    @like_myvideos = Kaminari.paginate_array(@like_myvideos).page(params[:page]).per(3)

  end

end
