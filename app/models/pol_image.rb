class PolImage < ActiveRecord::Base
  acts_as_commentable

  belongs_to :career
  belongs_to :comment

  # CarrierWave GEM
  mount_uploader :file, ListingUploader
  
end
