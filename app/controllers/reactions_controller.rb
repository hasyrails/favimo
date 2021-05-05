class ReactionsController < ApplicationController
  protect_from_forgery # ActionController::InvalidAuthenticityToken (ActionController::InvalidAuthenticityToken):対策
  skip_before_action :verify_authenticity_token # Can't verify CSRF token authenticity対策

  def create
    reaction = Reaction.find_or_initialize_by(to_user_id: params[:user_id], from_user_id: current_user.id)
    reaction.update_attributes(
      status: params[:reaction]
    )
  end
end
