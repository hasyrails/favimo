class Youtube::MyvideosController < ApplicationController
  def index
    q = params[:q]
    @my_videos = YoutubeVideo.all.where(status: 'default').where('title LIKE ?', '%'+q+'%')

    search_words = []
    @search_words = []
    youtube_videos = YoutubeVideo.order(created_at: "ASC").limit(5)

    youtube_videos.each do |youtube_video|
      search_word = youtube_video.search_keyword
      search_words << search_word
      @search_words = search_words.uniq
    end
  end
end
