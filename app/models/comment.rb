class Comment < ActiveRecord::Base

  belongs_to :career

  # -- acts_as_commentable ---------
  include ActsAsCommentable::Comment

  belongs_to :commentable, :polymorphic => true

  #default_scope -> { order('created_at ASC') }

  # NOTE: install the acts_as_votable plugin if you
  # want user to vote on the quality of comments.
  #acts_as_voteable

  # NOTE: Comments belong to a user
  belongs_to :user

  # -- closure tree -----------
  acts_as_tree name_column: "comment", order: "cached_votes_score desc"

  # -- acts_as_votable ------------
  acts_as_votable


  # -- Scopes ---------
  def self.top_voted
    includes(:career, {career: :politician})
      .where("cached_votes_score > 0")
      .order("cached_votes_score desc")
  end

  # -- Methods ----------
  def username_display
    if !self.user.nil? && (!self.user.username.blank? || !self.user.first_name.blank?)
      return self.user.username || self.user.first_name
    else
      return "Anonymous"
    end
  end

  def career
    Rails.cache.fetch("cmt_career_#{self.commentable_id}") do
      Career.find(self.commentable_id)
    end
  end

  def created_at_pretty
    self.created_at.strftime("%b %d %Y %l:%M%p")
  end
end
