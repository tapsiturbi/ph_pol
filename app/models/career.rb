class Career < ActiveRecord::Base
  belongs_to :politician
  belongs_to :location
end
