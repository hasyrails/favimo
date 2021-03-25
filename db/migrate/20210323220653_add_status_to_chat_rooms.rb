class AddStatusToChatRooms < ActiveRecord::Migration[6.0]
  def change
    add_column :chat_rooms, :status, :integer
  end
end
