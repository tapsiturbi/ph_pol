class CreatePoliticians < ActiveRecord::Migration
  def change
    create_table :politicians do |t|
      t.string :first_name
      t.string :last_name, :null => false
      t.string :nickname

      t.timestamps
    end
  end
end
