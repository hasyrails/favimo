class CreateChatRoomUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :chat_room_users do |t|
      t.references :chat_room, null: false, foreign_key: true, type: :string
      t.references :user, null: false, foreign_key: true, type: :string 
      
      t.timestamps
    end
  end
end
