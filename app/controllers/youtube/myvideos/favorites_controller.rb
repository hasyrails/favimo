class Youtube::Myvideos::FavoritesController < ApplicationController
  def create
    favorite = Favorite.create(
      youtube_video_id: params[:youtube_video_id], 
      user_id: current_user.id,
      status: params[:favorite]
    )

    youtube_video = YoutubeVideo.where(
      video_id: params[:youtube_video_unique_id],
      user_id: current_user.id
    )
    id = youtube_video.ids.first
    YoutubeVideo.find(id).update(
      status: params[:favorite]
    )
  end
end
