class CreateShareVideos < ActiveRecord::Migration[6.0]
  def change
    create_table :share_videos do |t|
      t.references :youtube_video, null: false, foreign_key: true
      t.references :to_user, null: false, foreign_key: { to_table: :users }, type: :string 
      t.references :from_user, null: false, foreign_key: { to_table: :users }, type: :string 

      t.timestamps
    end
  end
end
