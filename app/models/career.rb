class Career < ActiveRecord::Base
  acts_as_commentable

  belongs_to :politician
  belongs_to :location

  has_many :comment

  def self.current_with_loc_and_pol
    where(careers: {end_date: nil}).joins(:location, :politician)
  end

  def self.search(keywords)
    if keywords && !keywords.blank?
      where('locations.denorm_name like :keywords or politicians.first_name like :keywords or politicians.last_name like :keywords or careers.title like :keywords ', {keywords: "%#{keywords}%"})
    else
      all
    end
  end

  def self.in_municipal(municipal_id)
    if municipal_id && !municipal_id.blank?
      where('locations.id = :municipal_id or locations.parent_id = :municipal_id', {municipal_id: municipal_id})
    else
      all
    end
  end

  def self.in_province(province_id)
    if province_id && !province_id.blank?
      where('locations.id = :province_id or locations.parent_id = :province_id', {province_id: province_id})
    else
      all
    end
  end

  def comment_thread
    Comment.includes(:user).where(commentable_id: self.id).hash_tree
  end
end
