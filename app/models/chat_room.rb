class ChatRoom < ApplicationRecord
  include IdGenerator

  has_many :chat_room_users, dependent: :destroy
  has_many :users, through: :chat_room_users, dependent: :destroy
  has_many :chat_messages, dependent: :destroy
  enum status: { default: 0, dummy: 1 }
  
end
