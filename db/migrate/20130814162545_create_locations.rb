class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.integer :parent_id

      t.timestamps
    end
  end
end
