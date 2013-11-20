class AddCachedColumnsToUser < ActiveRecord::Migration
  def up
    add_column :users, :cached_score, :int
  end
  def down
    remove_column :users, :cached_score
  end
end
