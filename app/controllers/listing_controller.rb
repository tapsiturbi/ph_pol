class ListingController < ApplicationController
  helper_method :sort_column, :sort_direction

  # Controller that displays all Politicians
  def index
    params[:page] ||= 1
    @municipal_id = (params[:municipal] and !params[:municipal][:id].blank?) ? params[:municipal][:id] : ""
    @province_id = (params[:province] and !params[:province][:id].blank?) ? params[:province][:id] : ""

    # Retrieve info for dropdown
    @provinces = Location.provinces
    @municipals = Location.municipality(@province_id)


    # get Politicians based on their current career
    # -- we split these into two variables, one for pagination, one for looping thru
    #    all the records. This is necessary because all pagination gems gets confused
    #    if the query has groups/LEFT JOINs
    @careers = Career.current
      .with_loc_and_pol
      .search(params[:search])
      .in_municipal(@municipal_id)
      .in_province(@province_id)
      .page(params[:page])

    @careers_with_comments = @careers
      .order(sort_column + " " + sort_direction)
      .with_comments

  end

  # Displays one politician and all comments tied to him/her
  def show
    @politician = Politician.find(params[:id])

    @careers = Career.includes(:location, :politician).where(politician_id: @politician.id)

    @comment = Comment.new
  end

  # -- CUD Controllers -------------------------------------
  # Create comment - called via AJAX from listing#show
  def create_comment
    @career = Career.find(params[:career_id])
    @politician = @career.politician

    @comment = Comment.new(comment: params[:comment][:comment], user_id: current_user.id)
    if @comment.save && @career.add_comment(@comment)
      if params[:parent_comment_id]
        parent_comment = Comment.find(params[:parent_comment_id])
        parent_comment.add_child @comment
      end

      flash[:notice] = "Comment successfully created."
    end
  end

  # Create vote for a comment
  def create_vote

    @comment = Comment.find(params[:id])

    if current_user.present?
      # upvote
      if params[:vote] == "1"
        # if user already upvoted, then 'unvote'
        if current_user.voted_up_on? @comment
          @comment.unliked_by current_user
        else
          @comment.liked_by current_user
        end

      # downvote
      else
        # if user already downvoted, then 'undownvote'
        if current_user.voted_down_on? @comment
          @comment.undisliked_by current_user
        else
          @comment.disliked_by current_user
        end
      end

    end
  end

  private
  def sort_column
    %w[locations.denorm_name politicians.first_name politicians.last_name careers.title num_comments].include?(params[:sort]) ? params[:sort] : "num_comments"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end
end
