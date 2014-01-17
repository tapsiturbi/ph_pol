class CreateExternalLinks < ActiveRecord::Migration
  def self.up
    create_table :external_links do |t|
      t.belongs_to :comment, index: true
      t.string :link_url
      t.string :image_url
      t.string :title
      t.string :description
      t.timestamps
    end
  end

  def self.down
    drop_table :external_links
  end 
end
