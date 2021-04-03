class Youtube::VideosSearchController < ApplicationController
  before_action :authenticate_user!
  require 'google/apis/youtube_v3'
  require 'timeout'
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
    begin 
      Timeout.timeout(5) do 
        youtube.list_searches(:snippet, opt)
      end
    rescue Timeout::Error => e
      p 'タイムアウトです'
      p e.class
      p e.class.superclass
      p e.class.superclass.superclass
      @api_timeout_error_message = "現在、検索ができません"
    rescue Google::Apis::TransmissionError => e
      p "YouTubeAPIが使えない状態です"
      p e.class
      p e.class.superclass
      p e.class.superclass.superclass
      @api_timeout_error_message = "現在、検索ができません"
    end
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
      
      if @search_results.present?
        begin
          @search_results.items.each do |search_result|
            @youtube_video = YoutubeVideo.new(
              # id: id.next,
              # identify_id: search_result.id,
              video_id: search_result.id.video_id,
              title: search_result.snippet.title,
              description: search_result.snippet.description,
              published_at: search_result.snippet.published_at,
              channel_id: search_result.snippet.channel_id,
              channel_title: search_result.snippet.channel_title,
              thumbnail_url: search_result.snippet.thumbnails.default.url,
              search_keyword: params[:keyword],
              user_id: current_user.id
            )
            @youtube_video.save!
            # rescue ActiveRecord::RecordInvalid => e
            #   pp e.record.errors
            #   @youtube_videos << @youtube_video
        end
        rescue NoMethodError => e
          e.class
          @youtube_video = YoutubeVideo.new(
            # id: id.next,
            # identify_id: search_result.id,
            video_id: "",
            title: "",
            description: "",
            published_at: "",
            channel_id: "",
            channel_title: "",
            thumbnail_url: "",
            search_keyword: params[:keyword],
            user_id: current_user.id
          )
        end
      end
      redirect_to youtube_myvideos_path(q: params[:keyword]) and return
    end
  
    search_words = []
    @search_words = []
    youtube_videos = YoutubeVideo.order(created_at: 'ASC')

    youtube_videos.each do |youtube_video|
      search_word = youtube_video.search_keyword
      search_words << search_word
      @search_words = search_words.uniq
    end
    @search_words = Kaminari.paginate_array(@search_words).page(params[:page]).per(5)
  end

  private

end
