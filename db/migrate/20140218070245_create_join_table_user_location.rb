class CreateJoinTableUserLocation < ActiveRecord::Migration
  def change
#     create_join_table :users, :locations do |t|
#       t.index [:user_id, :location_id]
#       t.index [:location_id, :user_id]
#     end
    create_table :location_users, id: false do |t|
      t.column :user_id, :integer
      t.column :location_id, :integer
      t.index [:user_id, :location_id]
    end
  end
end
