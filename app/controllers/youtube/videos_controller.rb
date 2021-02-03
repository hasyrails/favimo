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
      max_results: 2,
      order: :date,
      page_token: next_page_token,
      published_after: after.iso8601,
      published_before: before.iso8601
    }
    youtube.list_searches(:snippet, opt)
  end

  def index
    @youtube_videos = []
    # if YoutubeVideo.last.nil?
    #   id = 1
    # else
    #   id = YoutubeVideo.last.id.next.step
    # end

    if params[:keyword].present?
      @search_results = find_videos(params[:keyword])
      @search_results.items.each do |search_result|
        @youtube_video = YoutubeVideo.new(
          # id: id.next,
          identify_id: search_result.id,
          video_id: search_result.id.video_id,
          title: search_result.snippet.title,
          description: search_result.snippet.description,
          published_at: search_result.snippet.published_at,
          channel_id: search_result.snippet.channel_id,
          channel_title: search_result.snippet.channel_title,
          thumbnail_url: search_result.snippet.thumbnails.default.url,
          user_id: current_user.id
        )
        @youtube_video.save!
        rescue ActiveRecord::RecordInvalid => e
          pp e.record.errors
        @youtube_videos << @youtube_video
      end
    else
      @search_results = find_videos('')
      @search_results.items.each do |search_result|
        @youtube_video = YoutubeVideo.new(
          # id: id.next,
          identify_id: search_result.id,
          video_id: search_result.id.video_id,
          title: search_result.snippet.title,
          description: search_result.snippet.description,
          published_at: search_result.snippet.published_at,
          channel_id: search_result.snippet.channel_id,
          channel_title: search_result.snippet.channel_title,
          thumbnail_url: search_result.snippet.thumbnails.default.url,
          user_id: current_user.id
        )
        @youtube_video.save!
        rescue ActiveRecord::RecordInvalid => e
          pp e.record.errors
        @youtube_videos << @youtube_video
      end
    end

  end

  private

end
