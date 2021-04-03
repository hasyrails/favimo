class CreateShareVideos < ActiveRecord::Migration[6.0]
  def change
    create_table :share_videos do |t|
      t.references :youtube_video, null: false, foreign_key: true
      t.references :to_user, null: false, foreign_key: { to_table: :users }, type: :string 
      t.references :from_user, null: false, foreign_key: { to_table: :users }, type: :string 

      t.timestamps
    end
  end
  add_foreign_key :share_videos, :youtube_video, column: :youtube_video_id
  add_foreign_key :share_videos, :to_user, column: :to_user_id
  add_foreign_key :share_videos, :from_user, column: :from_user_id
end
