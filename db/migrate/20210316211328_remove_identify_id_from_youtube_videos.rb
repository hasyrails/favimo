class RemoveIdentifyIdFromYoutubeVideos < ActiveRecord::Migration[6.0]
  def change
    remove_column :youtube_videos, :identify_id, :string
  end
end
