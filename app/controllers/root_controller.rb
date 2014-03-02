class RootController < ApplicationController
  def index
    @top_comments = Comment.top_voted.limit(10)
    @controversial = Career.controversial.limit(10)
    @active_users = User.with_most_comments.limit(10)

    @pol_in_location = []
    if current_user.present?
      user_locs = current_user.locations

      @pol_in_location = []
      #@pol_in_location = user_locs.empty? ? [] : Career.with_loc_and_pol.with_comments.where(locations: { id: current_user.locations.pluck(:id) } ).select_title_heirarchy.order("title_heirarchy")


      @user_votes = current_user.get_votes
    else
      @user_votes = []
    end
  end
end
