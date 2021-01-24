class Youtube::VideosController < ApplicationController
  require 'google/apis/youtube_v3'
  GOOGLE_API_KEY = Rails.application.credentials.google[:api_key]

  def create
    reaction = YoutubeVideo.create(
      user_id: current_user.id,
      status: params[:reaction],
      title: params[:title],
    )
  end

  def find_videos(keyword, after: 1.months.ago, before: Time.now)
    youtube = Google::Apis::YoutubeV3::YouTubeService.new
    youtube.key = GOOGLE_API_KEY

    next_page_token = nil
    opt = {
      q: keyword,
      type: 'video',
      max_results: 1,
      order: :date,
      page_token: next_page_token,
      published_after: after.iso8601,
      published_before: before.iso8601
    }
    youtube.list_searches(:snippet, opt)
  end

  def index
    if params[:keyword].present?
      @youtube_videos = find_videos(params[:keyword])
    else
      @youtube_videos = find_videos('')
    end
  end

end
