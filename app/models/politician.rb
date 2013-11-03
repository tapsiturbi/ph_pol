class Politician < ActiveRecord::Base
  has_many :careers

  # -- acts_as_votable ------------
  acts_as_votable

  def full_name
    return "#{self.first_name + ' ' if !self.first_name.nil?}#{self.last_name}"
  end

end
