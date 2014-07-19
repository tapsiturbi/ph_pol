class RootController < ApplicationController
  def index
    @top_comments = Comment.top_voted.limit(10)
    #@controversial = Career.controversial.limit(10)
    #@active_users = User.with_most_comments.limit(10)

    @tag_posts = []
    if current_user.present?
      user_locs = current_user.locations

      unless user_locs.empty?
        @tag_posts = user_locs.includes(:careers, {careers: [:politician, :comment]}, { careers: { comment: [:pol_image, :external_link] }}).where(comments: { commentable_type: "Career"}).order("comments.created_at")
      end




      @user_votes = current_user.get_votes
    else
      @user_votes = []
    end
  end
end
