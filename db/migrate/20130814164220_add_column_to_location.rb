class AddColumnToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :name, :string
    add_index :locations, :name
  end
end
