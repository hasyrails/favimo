class CreateYoutubeVideos < ActiveRecord::Migration[6.0]
  def change
    create_table :youtube_videos do |t|
      t.string :identify_id
      t.string :video_id
      t.string :title
      t.string :description
      t.datetime :published_at
      t.string :channel_id
      t.string :channel_title
      t.string :thumbnail_url
      t.integer :status, null: false, default: 0
      t.integer :is_remaining, null: false, default: 0
      t.string :search_keyword
      t.references :user, null: false, foreign_key: true, type: :string 

      t.timestamps
    end
  end
end
