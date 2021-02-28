class YoutubeVideo < ApplicationRecord
  
  has_many :favorites, dependent: :destroy
  has_many :users, through: :favorites
  has_many :users, through: :share_videos

  enum status: { default: 0, like: 1, dislike: 2 }
  enum is_remaining: { true: 0, false: 1 }
  validates :video_id, uniqueness: { scope: :user_id }
end
