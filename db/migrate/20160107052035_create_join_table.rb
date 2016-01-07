class CreateJoinTable < ActiveRecord::Migration
  def change
    create_join_table :Tags, :Data do |t|
      t.index [:tag_id, :datum_id]
      t.index [:datum_id, :tag_id]
    end
  end
end
