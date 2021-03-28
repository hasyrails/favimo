class CreateChatMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :chat_messages do |t|
      t.references :chat_room, null: false, foreign_key: true, type: :string
      t.references :user, null: false, foreign_key: true, type: :string 
      t.text :content

      t.timestamps
    end
  end
end
