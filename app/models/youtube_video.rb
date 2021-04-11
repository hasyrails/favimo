class YoutubeVideo < ApplicationRecord
  has_many :favorites, dependent: :destroy
  has_many :users, through: :favorites
  has_many :users, through: :share_videos

  enum status: { default: 0, like: 1, dislike: 2, dammy: 3 }
  enum is_remaining: { remaining: 0, not_remaining: 1 }
  validates :video_id, uniqueness: { scope: :user_id }
end
