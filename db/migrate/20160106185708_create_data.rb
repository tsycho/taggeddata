class CreateData < ActiveRecord::Migration
  def change
    create_table :data do |t|
      t.decimal :value
      # t.integer :tags, array: true, default: []

      t.timestamps null: false
    end
  end
end
