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

  # -- awesome_nested_set ---------
#   acts_as_nested_set
# 
#   def new
#     Comment.create(comment_params)
#   end
# 
#   def create
#     Comment.create(comment_params)
#   end
# 
# 
#   def self.find_root_of_career(career_id)
#     Comment.find_comments_for_commentable(Career, career_id)
#   end
# 
# 
#   private
#     def comment_params
#       params.require(:comment).permit(:comment, :parent_id, :title)
#     end

  # -- closure tree -----------
  acts_as_tree name_column: "comment"
end
