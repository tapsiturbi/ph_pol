class AddCommentIdToPolImage < ActiveRecord::Migration
  def self.up
    add_column :pol_images, :comment_id, :integer
  end

  def self.down
    remove_column :pol_images, :comment_id
  end
end
