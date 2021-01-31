class QiitasController < ApplicationController
  require "qiita"
  require 'net/http'
  require 'json'

  PER_PAGE = 100
  QIITA_ACCESS_TOKEN = Rails.application.credentials.qiita[:access_token]
  GET_ITEMS_URI = 'https://qiita.com/api/v2/items'


  def create
    reaction = YoutubeVideo.create(
      user_id: current_user.id,
      status: params[:reaction],
      title: params[:title],
    )
  end

  def search(query, page: 1)
    puts "API Search Condition: query:'#{query}', page:#{page}"

    # リクエスト情報を作成
    uri = URI.parse (GET_ITEMS_URI)
    uri.query = URI.encode_www_form({ query: query, per_page: PER_PAGE, page: page })
    req = Net::HTTP::Get.new(uri.request_uri)
    req['Authorization'] = "Bearer #{QIITA_ACCESS_TOKEN}"

    # リクエスト送信
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    res = http.request(req)

    # 次ページを計算 (API仕様 上限は100ページ)
    total_page = ((res['total-count'].to_i - 1) / PER_PAGE) + 1
    total_page = (total_page > 100) ? 100 : total_page
    next_page = (page < total_page) ? page + 1 : nil

    # API 残り使用回数、リセットされる時刻を表示
    puts "API Limit:#{res['rate-remaining']}/#{res['rate-limit']}, reset:#{Time.at(res['rate-reset'].to_i)}"

    # 返却 [HTTPステータスコード, 次ページ, 記事情報の配列]
    remain = res['rate-remaining']
    code = res.code.to_i
    json = JSON.parse(res.body)
    return remain, code, next_page, json
  end
  

  def index
    @search_results = search('created:>=2019-04-01 created:<=2019-04-01')
    @remain = @search_results[0]
    @body = @search_results[3]
    @body_content = @search_results[3][1]["rendered_body"].html_safe
    @body_content_coediting = @search_results[3][1]["coediting"]
    @body_content_comments_count = @search_results[3][1]["comments_count"]
    @body_content_created_at = @search_results[3][1]["created_at"]
    @body_content_tag_name = @search_results[3][1]["tags"][0]["name"]
    @body_content_tag_name_2 = @search_results[3][1]["tags"][1]["name"]
    @body_content_title = @search_results[3][1]["title"]
    @body_content_second = @search_results[3][2]["rendered_body"].html_safe
    @body_content_third = @search_results[3][3]["rendered_body"].html_safe
    @body_content_fourth = @search_results[3][4]["rendered_body"].html_safe
    @body_content_fifth = @search_results[3][5]["rendered_body"].html_safe
    @body_content_sixth = @search_results[3][6]["rendered_body"].html_safe
    @body_content_seventh = @search_results[3][7]["rendered_body"].html_safe
    @body_content_eighth = @search_results[3][8]["rendered_body"].html_safe
    @body_content_ninth = @search_results[3][9]["rendered_body"].html_safe
  end

end
