class ChatMessage < ApplicationRecord
  belongs_to :user
  belongs_to :chat_room

  enum status: { default: 0, dummy: 1 }

  after_create_commit { ChatMessageBroadcastJob.perform_later self }
end
