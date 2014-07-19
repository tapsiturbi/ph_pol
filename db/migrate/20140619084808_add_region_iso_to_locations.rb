class AddRegionIsoToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :region_iso, :string
  end
end
