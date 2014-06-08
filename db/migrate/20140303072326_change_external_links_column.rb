class ChangeExternalLinksColumn < ActiveRecord::Migration
  def change
    change_table :external_links do |t|
      t.change :link_url, :string, :limit => 32767
      t.change :image_url, :string, :limit => 32767
    end
  end
end
