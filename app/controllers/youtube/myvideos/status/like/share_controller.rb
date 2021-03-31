class Youtube::Myvideos::Status::Like::ShareController < ApplicationController
  def new
    @user = current_user
    @share_video = YoutubeVideo.find(params[:id])

    like_reactions_by_current_user = Reaction.where(from_user_id: current_user.id, status: "like")

    @users_liked_by_current_user = []

    like_reactions_by_current_user.each do |like_reaction|
      user_liked_by_current_user = User.find(like_reaction.to_user_id)
      @users_liked_by_current_user << user_liked_by_current_user
    end

    @users_liked_by_current_user = Kaminari.paginate_array(@users_liked_by_current_user).page(params[:page]).per(8)
  end

  def create
    @user = User.find_by(id: params[:to_user_id])

    youtube_video = YoutubeVideo.find_by(video_id: params[:youtube_video_id])

    share = ShareVideo.create!(
      youtube_video_id: youtube_video.id,
      from_user_id: params[:from_user_id],
      to_user_id: params[:to_user_id]
    )

    redirect_to user_path(@user, params:{
      share_video_unique_id: params[:youtube_video_id]
    }), notice: "動画を共有しました:<br>#{youtube_video.title}"
  end
end
