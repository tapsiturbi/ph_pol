class ChangeCommentTitleLength < ActiveRecord::Migration
  def change
    change_table :comments do |t|
      t.change :title, :string, :limit => 255
    end
  end
end
