class AddColumnToChatMessage < ActiveRecord::Migration[6.0]
  def change
    add_column :chat_messages, :status, :string, default: 0
  end
end
