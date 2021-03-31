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

  def update
    @youtube_video = YoutubeVideo.find(params[:id])  
    @youtube_video.update!(
      status: params[:favorite]
    )

    @favorite = Favorite.find(@youtube_video.favorites.ids.first)
    @favorite.update!(
      status: params[:favorite]
    )

    if params[:favorite] == 'like'
      redirect_to youtube_myvideos_status_like_index_path, notice: "動画のステータスをLikeにしました"
    elsif params[:favorite] == 'dislike'
      redirect_to youtube_myvideos_status_dislike_index_path, notice: "動画のステータスをDisLikeにしました"
    end
  end

  private
  
  def youtube_video_params
    params.require(:youtube_video).permit(:status)
  end

  def favorite_params
    params.require(:favorite).permit(:status)
  end
end
