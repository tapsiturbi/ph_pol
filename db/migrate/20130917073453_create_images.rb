class CreateImages < ActiveRecord::Migration
  def self.up
    create_table :pol_images do |t|
      t.string :file

      t.belongs_to :career, index: true
      t.timestamps
    end

    #add_index :pol_images, [:commentable_id, :file]
  end

  def self.down
    drop_table :pol_images
  end
end
