class PolImage < ActiveRecord::Base
  acts_as_commentable

  belongs_to :career

  has_many :comment

  # CarrierWave GEM
  mount_uploader :file, ListingUploader
  
end
