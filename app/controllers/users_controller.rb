class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:user_id])

    @share_video = YoutubeVideo.where(video_id: params[:share_video_unique_id]).first
  end

  def index
    if Reaction.where(from_user_id: current_user.id).where.not(status: "like").blank?
      @users = User.where.not(id: current_user.id).where.not(role: "dummy")
    else
      non_dummy_users = []
      non_dummy_users.push(User.general).push(User.admin).push(User.demo_admin)
      non_dummy_users = non_dummy_users.flatten

      non_dummy_users.reject! do |non_dummy_user|
        non_dummy_user.id == current_user.id
      end

      non_dummy_user_ids = []

      non_dummy_users.each do |non_dummy_user|
        non_dummy_user_ids << non_dummy_user.id
      end

      non_like_reactions = Reaction.where(to_user_id: non_dummy_user_ids, from_user_id: current_user.id).where.not(status: "like")

      non_like_user_ids = non_like_reactions.map(&:to_user_id) 

      @users = User.find(non_like_user_ids)

    end
    # binding.pry

    @user = User.find(current_user.id)
  end
end
