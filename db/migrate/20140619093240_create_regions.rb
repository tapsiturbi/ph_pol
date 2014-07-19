class CreateRegions < ActiveRecord::Migration
  def change
    create_table :regions, { :id => false, :primary_key => 'region_iso' } do |t|
      t.string :region_iso, :null => false
      t.string :region_name
    end
  end
end
