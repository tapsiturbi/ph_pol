class AddCachedColumnsToUser < ActiveRecord::Migration
  def up
    add_column :users, :cached_score, :int

    execute <<-SQL
      UPDATE users AS u
        INNER JOIN (
          SELECT user_id, sum(cached_votes_score) as sum_score
          FROM comments
          GROUP BY user_id
        ) c on c.user_id = u.id
      SET u.cached_score = c.sum_score
    SQL
  end
  def down
    remove_column :users, :cached_score
  end
end
