class Comment < ActiveRecord::Base

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

end
