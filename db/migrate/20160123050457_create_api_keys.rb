class CreateApiKeys < ActiveRecord::Migration
  def change
    create_table :api_keys do |t|
      t.integer :user_id,   null: false
      t.string :key,        null: false
    end

    add_index :api_keys, :key, unique: true
    add_foreign_key :api_keys, :users, on_delete: :cascade
  end
end
