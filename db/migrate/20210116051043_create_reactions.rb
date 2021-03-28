class CreateReactions < ActiveRecord::Migration[6.0]
  def change
    create_table :reactions do |t|
      t.references :to_user, null: false, foreign_key: { to_table: :users }, type: :string 
      t.references :from_user, null: false, foreign_key: { to_table: :users }, type: :string 
      t.integer :status, null: false

      t.timestamps
    end
  end
end
