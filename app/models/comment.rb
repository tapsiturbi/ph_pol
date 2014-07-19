class Comment < ActiveRecord::Base

  belongs_to :career, :foreign_key => :commentable_id

  # -- acts_as_commentable ---------
  include ActsAsCommentable::Comment

  belongs_to :commentable, :polymorphic => true
  belongs_to :user
  has_one :pol_image
  has_one :external_link

  # -- closure tree -----------
  acts_as_tree name_column: "comment", order: "cached_votes_score desc"

  # -- acts_as_votable ------------
  acts_as_votable


  # -- Scopes ---------
  def self.top_voted
    roots.includes(:career, {career: :politician})
      .where("cached_votes_score >= 0 or created_at > ?", 6.hours.ago)
      .order("cached_votes_score desc")
  end

  def self.posts
    joins("LEFT JOIN external_links ON external_links.comment_id = comments.id")
      .where(parent_id: nil)
      .where("(comments.title IS NOT NULL OR external_links.title IS NOT NULL)")
  end

  # -- Methods ----------
  def username_display
    if !self.user.nil? && (!self.user.username.blank? || !self.user.first_name.blank?)
      return self.user.username || self.user.first_name
    else
      return "Anonymous"
    end
  end

  def pretty_title
    return self.title.blank? ? (self.external_link.blank? || self.external_link.title.blank? ? "" : self.external_link.title ) : self.title
  end

  def has_image?
    if self.pol_image.nil? || self.pol_image.file_url.blank? || self.external_link.nil? || self.external_link.image_url.blank?
      return false
    else
      return true
    end
  end

  def style_defaults(css_class)
    image_url = self.image_url
    if image_url.blank?
      return "class=\"#{css_class} no-image\""
    end

    return "class=\"#{css_class}\" style=\"background-image: url('#{image_url}');\""
  end
  
  def image_url
    if !self.pol_image.nil? && !self.pol_image.file_url.blank?
      return self.pol_image.file_url(:medium)
    elsif !self.external_link.blank? && !self.external_link.image_url.blank?
      return self.external_link.image_url
    end
    return ""
  end

  def career
    Career.find(self.commentable_id)
  end

  def created_at_pretty
    self.created_at.strftime("%b %d %Y %l:%M%p")
  end
end
