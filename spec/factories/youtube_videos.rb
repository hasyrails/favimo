# create_table "youtube_videos", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
#   t.string "video_id"
#   t.string "title"
#   t.string "description"
#   t.datetime "published_at"
#   t.string "channel_id"
#   t.string "channel_title"
#   t.string "thumbnail_url"
#   t.integer "status", default: 0, null: false
#   t.integer "is_remaining", default: 0, null: false
#   t.string "search_keyword"
#   t.string "user_id", null: false
#   t.datetime "created_at", precision: 6, null: false
#   t.datetime "updated_at", precision: 6, null: false
#   t.index ["user_id"], name: "index_youtube_videos_on_user_id"
# end

FactoryBot.define do
  factory :youtube_video do
    video_id { 
      "qLznJ3RZc_w"
    } 
    title { 
      "【海外の反応】進撃の巨人４期１６話　エレン巨人化とライナー登場に大興奮！！" 
    }
    description {
      "【Neuralex Live】 【元動画 / original video】 https://youtu.be/LIXx63TZ9O8 【元チャンネル / original channel】 ..."
    } 
    channel_id {
      "UCFJJhhd_T1aipOGH4EHW69w"
    } 
    channel_title {
      "Translation Senpai"
    }
    thumbnail_url {
      "https://i.ytimg.com/vi/qLznJ3RZc_w/default.jpg"
    }
    association :user
  end
end

