class Location < ActiveRecord::Base
  has_many :children, class_name: "Location", foreign_key: "parent_id"
  belongs_to :parent, class_name: "Location", foreign_key: "parent_id"

  #has_and_belongs_to_many :users
  has_many :location_users, dependent: :destroy
  has_many :users, through: :location_users

  has_many :careers
  
  default_scope { order('name asc') }

  def self.provinces
    where("parent_id is null")
  end

  def self.municipality(province_id)
    return province_id.blank? ? nil : self.where("parent_id = ?", province_id)
  end

  def self.get_nationwide
    where("lower(name) = 'nationwide'").first
  end

end
