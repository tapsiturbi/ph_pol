class Region < ActiveRecord::Base
  self.primary_key = :region_iso

  #has_and_belongs_to_many :users, join_table: "users_regions", foreign_key: "region_iso"
end