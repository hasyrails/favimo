class MatchingController < ApplicationController
  before_action :authenticate_user!

  def index
    got_reaction_user_ids = Reaction.where(to_user_id: current_user.id, status: 'like').pluck(:from_user_id)
    
    @match_users = Reaction.where(from_user_id: got_reaction_user_ids, from_user_id: current_user.id, status: 'like').map(&:to_user)
    @match_users = Kaminari.paginate_array(@match_users).page(params[:page]).per(5)
    
    @user = User.find(current_user.id)

  end
end
