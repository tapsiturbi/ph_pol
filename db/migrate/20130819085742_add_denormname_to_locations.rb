class AddDenormnameToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :denorm_name, :string
  end
end
