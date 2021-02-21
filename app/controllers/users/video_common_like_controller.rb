class Users::VideoCommonLikeController < ApplicationController
  def index
    youtube_video_liked_by_other_users = YoutubeVideo.where(status: "like", video_id: params[:video_unique_id]).where.not(user_id: current_user.id)
    
    @common_video_like_users = []

    youtube_video_liked_by_other_users.each do |youtube_video|
      common_video_like_user = User.find(youtube_video.user_id)
      @common_video_like_users << common_video_like_user
    end
    
  end
end
