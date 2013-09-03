class Career < ActiveRecord::Base
  acts_as_commentable

  belongs_to :politician
  belongs_to :location

  has_many :comment


  #-- Scopes ----------------------------

  def self.controversial
    with_loc_and_pol
      .joins(:comments)
      .group("careers.id, careers.title, locations.id, locations.denorm_name, politicians.id, politicians.first_name, politicians.last_name")
      .select("count(comments.id) as num_comments, careers.id, careers.title, locations.id, locations.denorm_name as location_denorm_name, politicians.id as politician_id, politicians.first_name as politician_first_name, politicians.last_name as politician_last_name")
      .having("num_comments > 0")
      .order("num_comments desc")
  end

  def self.with_comments
    joins("LEFT JOIN comments ON comments.commentable_id = careers.id AND comments.commentable_type = 'Career'")
      .group("careers.id, careers.title, locations.id, locations.denorm_name, politicians.id, politicians.first_name, politicians.last_name")
      .select("sum(comments.cached_votes_score) as num_votes, count(comments.id) as num_comments, careers.id, careers.title, locations.id, locations.denorm_name as location_denorm_name, politicians.id as politician_id, politicians.first_name as politician_first_name, politicians.last_name as politician_last_name")
  end
  def self.with_comments_no_group
    joins("INNER JOIN comments ON comments.commentable_id = careers.id AND comments.commentable_type = 'Career'")
  end

  def self.current
    where(careers: {end_date: nil})
  end

  def self.with_loc_and_pol
    joins(:location, :politician)
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

  def politician_display
    return "#{self.politician.first_name} #{self.politician.last_name}"
  end
end
