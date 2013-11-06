class Career < ActiveRecord::Base
  acts_as_commentable

  belongs_to :politician
  belongs_to :location

  has_many :comment, :dependent => :destroy
  has_many :pol_image, :dependent => :destroy

  #-- Scopes ----------------------------

  def self.controversial
    with_loc_and_pol
      .joins(:comments)
      .group("careers.id, careers.title, locations.id, locations.denorm_name, politicians.id, politicians.first_name, politicians.last_name")
      .select("count(comments.id) as num_comments, careers.id, careers.title, locations.id, locations.denorm_name as location_denorm_name, politicians.id as politician_id, politicians.first_name as politician_first_name, politicians.last_name as politician_last_name")
      .having("count(comments.id) > 0")
      .order("count(comments.id) desc")
  end

  def self.with_comments
    joins("LEFT JOIN comments ON comments.commentable_id = careers.id AND comments.commentable_type = 'Career'")
      .group("careers.id, careers.title, locations.id, locations.denorm_name, politicians.id, politicians.first_name, politicians.last_name")
      .select("sum(comments.cached_votes_score) as num_votes, count(comments.id) as num_comments, careers.id, careers.title, locations.id, locations.denorm_name as location_denorm_name, politicians.id as politician_id, politicians.first_name as politician_first_name, politicians.last_name as politician_last_name")
  end
  def self.with_comments_no_group
    joins("INNER JOIN comments ON comments.commentable_id = careers.id AND comments.commentable_type = 'Career'")
  end

  def self.with_comments_from_user(user_id)
    joins("INNER JOIN comments ON comments.commentable_id = careers.id AND comments.commentable_type = 'Career'")
    .where("comments.user_id = ?", user_id)
    .group("careers.id, careers.start_date, careers.end_date, careers.title, careers.politician_id, careers.location_id, careers.created_at, careers.updated_at")
  end

  def self.current
    where(careers: {end_date: nil})
  end

  def self.with_loc_and_pol
    joins(:location, :politician)
  end

  def self.with_images
    includes(:pol_image)
  end

  def self.search(keywords)
    if keywords && !keywords.blank?
      where('locations.denorm_name ilike :keywords or politicians.first_name ilike :keywords or politicians.last_name ilike :keywords or careers.title ilike :keywords ', {keywords: "%#{keywords}%"})
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

  #-- Methods ----------------------------

  def comments_by_user(user_id)
    Rails.cache.fetch("car_cmt_user_#{self.id}_#{user_id}") do
      comments.where("user_id = ?", user_id)
    end
  end

  def comment_thread
    Comment.includes(:user).where(commentable_id: self.id).hash_tree
  end

  def posts(limit_depth = 3)
    Comment
      .includes(:user)
      .where({commentable_id: self.id, commentable_type: "Career"})
      .hash_tree(limit_depth: limit_depth)
  end

  def politician_display
    Rails.cache.fetch("car_pol_disp_#{self.id}") do
      "#{self.politician.first_name} #{self.politician.last_name}"
    end
  end

  def location_display
    Rails.cache.fetch("car_loc_disp_#{self.id}") do
      self.location.denorm_name
    end
  end
end
