class ListingController < ApplicationController
  helper_method :sort_column, :sort_direction

  # Controller that displays all Politicians
  def index
    params[:page] ||= 1
    @municipal_id = (params[:municipal] and !params[:municipal][:id].blank?) ? params[:municipal][:id] : ""
    @province_id = (params[:province] and !params[:province][:id].blank?) ? params[:province][:id] : ""

    # get Politicians based on their current career
    @careers = Career
      .includes(:location, :politician)
      .where("end_date is null")

    # Keyword filter
    if !params[:search].blank?
      @careers = @careers.where('locations.denorm_name like :keywords or politicians.first_name like :keywords or politicians.last_name like :keywords or title like :keywords ', {keywords: "%#{params[:search]}%"})
    end

    # Province/municipal filter
    if !@municipal_id.blank?
      @careers = @careers.where('locations.id = :municipal_id or locations.parent_id = :municipal_id', {municipal_id: @municipal_id})
    elsif !@province_id.blank?
      @careers = @careers.where('locations.id = :province_id or locations.parent_id = :province_id', {province_id: @province_id})
    end

    # Sorting
    @careers = @careers.order(sort_column + " " + sort_direction).paginate(:per_page => 25, :page => params[:page])

    # Retrieve info for dropdown
    @provinces = Location.where("parent_id is null").order("name asc")
    if !@province_id.blank?
      @municipals = Location.where("parent_id = ?", @province_id).order("name asc")
    else
      @municipals = nil
    end

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
    %w[locations.denorm_name politicians.first_name politicians.last_name title].include?(params[:sort]) ? params[:sort] : "title"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
