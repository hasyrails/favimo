class Users::Status::LikeController < ApplicationController
  def index
    @user = User.find(params[:id])

    like_reactions = Reaction.where(from_user_id: @user.id, status: "like").order(created_at: "DESC")

    like_reaction_dates = []
    like_reactions.each do |like_reaction|
      like_reaction_dates << like_reaction.created_at
    end

    @like_reaction_dates = like_reaction_dates

    like_user_ids = Reaction.where(from_user_id: @user.id, status: "like").order(created_at: "DESC").map(&:to_user_id)
   
    like_users = []
    like_user_ids.each do |like_user_id|
      like_users << User.find(like_user_id)
    end

    @like_users = like_users
    @like_users = Kaminari.paginate_array(@like_users).page(params[:page]).per(5)

    got_reaction_user_ids = Reaction.where(to_user_id: current_user.id, status: 'like').pluck(:from_user_id)

    @match_users = Reaction.where(to_user_id: got_reaction_user_ids, from_user_id: current_user.id, status: 'like').map(&:to_user)

    # binding.pry

  end
end
