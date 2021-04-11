class User < ApplicationRecord
  include IdGenerator

  has_many :youtube_videos, dependent: :destroy
  has_many :reactions, foreign_key: :from_user_id, dependent: :destroy
  has_many :reactions, foreign_key: :to_user_id, dependent: :destroy
  has_many :chat_room_users, dependent: :destroy
  has_many :chat_rooms, through: :chat_room_users, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :youtube_videos, through: :favorites, dependent: :destroy
  has_many :share_videos, foreign_key: :from_user_id, dependent: :destroy
  has_many :share_videos, foreign_key: :to_user_id, dependent: :destroy
  has_many :youtube_videos, through: :share_videos, dependent: :destroy
  has_many :chat_messages, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  validates :name, presence: true
  validates :self_introduction, length: { maximum: 500 }

  enum gender: { male: 0, female: 1 }
  enum role: { general: 0, admin: 1, demo_admin: 2, dammy: 3, guest: 4}

  mount_uploader :profile_image, ProfileImageUploader

  def update_without_current_password(params, *options)

    if params[:password].blank? && params[:password_confirmation].blank?
      params.delete(:password)
      params.delete(:password_confirmation)
    end

    result = update_attributes(params, *options)
    clean_up_passwords
    result
  end
  
  def self.guest
    find_or_create_by!(email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "ゲストユーザー"
      user.role = "guest"
      # user.confirmed_at = Time.now  # Confirmable を使用している場合は必要
    end
  end
end
