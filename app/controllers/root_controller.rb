class RootController < ApplicationController
  def index
    @top_comments = Comment.top_voted.limit(10)
    @controversial = Career.controversial.limit(10)
  end
end
