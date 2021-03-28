class CreateChatRooms < ActiveRecord::Migration[6.0]
  def change
    create_table :chat_rooms, id: false do |t|
      t.string :id, limit: 36, null: false, primary_key: true
      t.timestamps
    end
  end
end
