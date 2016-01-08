class CreateJoinTable < ActiveRecord::Migration
  def change
    create_join_table :data, :tags do |t|
      t.index [:datum_id, :tag_id]
      t.index [:tag_id, :datum_id]
    end
  end
end
