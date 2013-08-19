class Career < ActiveRecord::Base
  belongs_to :politician
  belongs_to :location

  def self.search(keywords)
    if keywords
      where('locations.denorm_name like :keywords or politicians.first_name like :keywords or politicians.last_name like :keywords or title like :keywords ', {keywords: "%#{keywords}%"})
    else
      scoped
    end
  end
end
