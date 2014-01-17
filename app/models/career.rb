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
      .select("sum(comments.cached_votes_score) as num_votes, count(comments.id) as num_comments, careers.id, careers.title, locations.id, locations.denorm_name as location_denorm_name, politicians.id as politician_id, politicians.first_name as politician_first_name, politicians.last_name as politician_last_name, politicians.nickname as politician_nickname")
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

  # adds sql select that allows us to sort by heirarcy (pres, vice pres, senator, etc)
  def self.select_title_heirarchy
    select("case when upper(careers.title) = 'PRESIDENT' then 1
          when upper(careers.title) = 'VICE-PRESIDENT' then 2
          when upper(careers.title) = 'SENATOR' then 3
          when upper(careers.title) in ('CONGRESSMAN', 'ASSEMBLYMAN', 'PARTY-LIST') then 4
          when upper(careers.title) in ('GOVERNOR', 'PROVINCIAL GOVERNOR') then 5
          when upper(careers.title) in ('VICE-GOVERNOR', 'PROVINCIAL VICE-GOVERNOR') then 6
          when upper(careers.title) in ('MAYOR', 'CITY MAYOR') then 7
          when upper(careers.title) in ('VICE-MAYOR', 'CITY VICE-MAYOR') then 8
          else 9
          end as title_heirarchy")
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

  # Returns an hash/object containing the following:
  #     :count = total number of rows
  #     :hash = hash_tree of all posts that are within the page_number/page_size range
  #     :page_number = page_number from parameter
  #     :page_size = page_size from parameter
  def posts(target_cmt_id = nil, page_number = 1, page_size = 3, limit_depth = 3)
    puts "limit_depth = #{limit_depth}, page_number=#{page_number}, page_size=#{page_size}"
    query = Comment
              .includes(:user, :external_link, :pol_image)
              .where({commentable_id: self.id, commentable_type: "Career"})

    if !target_cmt_id.blank?
      query = query.where({id: target_cmt_id })
    end

    hash = query.hash_tree(limit_depth: limit_depth)
    count = hash.length

    # Pagination
    # * not very efficient - only does the filter after the hash has been saved
    # in RAM
    if !page_number.nil? && !page_size.nil?
      start_idx = (page_number-1) * page_size
      end_idx = (page_number * page_size) - 1
      hash = Hash[Array(hash)[start_idx..end_idx]]
    end

    return { count: count, hash: hash, page_number: page_number, page_size: page_size }
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
