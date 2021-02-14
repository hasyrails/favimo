class Youtube::MyvideosController < ApplicationController
  def index
    q = params[:q]
    @my_videos = YoutubeVideo.all.where(status: 'default').where('title LIKE ?', '%'+q+'%')
  end
end
