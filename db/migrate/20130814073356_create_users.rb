class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      #t.string  :email
      t.string  :username
      #t.string  :password_hash

      t.string  :first_name
      t.string  :last_name

      #t.string  :facebook_id

      t.timestamps
    end
  end
end
