class Politician < ActiveRecord::Base
  has_many :careers

  # -- acts_as_votable ------------
  acts_as_votable

end
