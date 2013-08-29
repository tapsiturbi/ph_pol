class Location < ActiveRecord::Base
  has_many :children, class_name: "Location", foreign_key: "parent_id"
  belongs_to :parent, class_name: "Location", foreign_key: "parent_id"

  default_scope { order('name asc') }

  def self.provinces
    where("parent_id is null")
  end

  def self.municipality(province_id)
    return province_id.blank? ? nil : self.where("parent_id = ?", province_id)
  end
end
