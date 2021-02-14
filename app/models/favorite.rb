class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :youtube_video

  enum status: { like: 0, dislike: 1 }
  
  validates :youtube_video_id, uniqueness: true
end
