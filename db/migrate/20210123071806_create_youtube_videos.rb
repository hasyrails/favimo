class CreateYoutubeVideos < ActiveRecord::Migration[6.0]
  def change
    create_table :youtube_videos do |t|
      t.string :identify_id
      t.string :video_id
      t.string :title
      t.string :description
      t.string :channel_id
      t.string :channel_title
      t.string :thumbnail_url
      t.integer :status, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
