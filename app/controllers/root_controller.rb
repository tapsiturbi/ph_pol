class RootController < ApplicationController
  def index
    @top_comments = Comment.top_voted.limit(10)
    @controversial = Career.controversial.limit(10)
    @active_users = User.with_most_comments.limit(10)
  end
end
