class CreateReactions < ActiveRecord::Migration[6.0]
  def change
    create_table :reactions do |t|
      t.references :to_user, null: false, foreign_key: { to_table: :users }, type: :string 
      t.references :from_user, null: false, foreign_key: { to_table: :users }, type: :string 
      t.integer :status, null: false

      t.timestamps
    end
    add_foreign_key :reactions, :to_user, column: :to_user_id
    add_foreign_key :reactions, :from_user, column: :from_user_id
  end
end
