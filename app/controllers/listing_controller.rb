class ListingController < ApplicationController
  helper_method :sort_column, :sort_direction

  # Controller that displays all Politicians
  def index
    params[:page] ||= 1
    @municipal_id = (params[:municipal] and !params[:municipal][:id].blank?) ? params[:municipal][:id] : ""
    @province_id = (params[:province] and !params[:province][:id].blank?) ? params[:province][:id] : ""

    # Retrieve info for dropdown
    @nationwide = Location.get_nationwide
    @provinces = Location.provinces.where('id != ?', @nationwide.id).collect {|p| [p.name.capitalize, p.id]}.insert(0, [@nationwide.name.capitalize, @nationwide.id])
    @municipals = Location.municipality(@province_id)

    # get Politicians based on their current career
    # -- we split these into two variables, one for pagination, one for looping thru
    #    all the records. This is necessary because all pagination gems gets confused
    #    if the query has groups/LEFT JOINs
    @careers = Career.current
      .select_title_heirarchy
      .with_loc_and_pol
      .search(params[:search])
      .in_municipal(@municipal_id)
      .in_province(@province_id)
      .page(params[:page])

    @careers_with_comments = @careers
      .order(sort_column + " " + sort_direction + ", politicians.id")
      .with_comments

  end

  # Displays one politician and all comments tied to him/her
  def show
    @page = (params.has_key?(:page) ? params[:page].to_i : 1)
    @politician = Politician.find(params[:id])
    @target_cmt_id = params[:cmt_id]

    @careers = Career.with_loc_and_pol.where(politician_id: @politician.id)

    @comment = Comment.new
    @new_image = PolImage.new

    if current_user.present?
      @user_votes = current_user.get_votes_of_pol(@politician.id)
    else
      @user_votes = []
    end

  end

  # Allow users to select province/location
  def location
    # Retrieve info for dropdown
    @nationwide = Location.get_nationwide
    @provinces = Location.provinces.where('id != ?', @nationwide.id).collect {|p| [p.name.capitalize, p.id]}.insert(0, [@nationwide.name.capitalize, @nationwide.id])

    # Retrieve previously selected locations
    @curr_locations = current_user.present? ? current_user.locations : []
  end

  # -- CUD Controllers -------------------------------------

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

    if !@comment.user.nil?
      @comment.user.update_cache
    end
    @user_votes = current_user.get_votes_of_pol(@comment.commentable.politician.id)
  end

  # Upload image
  def create_image

    if current_user.present?
      @career = Career.find(params[:career_id])

      @image = PolImage.new
      @image.career = @career
      if params[:pol_image].has_key?(:remote_file_url) && !params[:pol_image][:remote_file_url].blank?
        puts "saving with remote_file_url"
        @image.remote_file_url = params[:pol_image][:remote_file_url]
      else
        puts "saving with file"
        @image.file = params[:pol_image][:file]
      end
      
      if @image.save
        flash[:notice] = "Photo uploaded successfully"
      else
        flash[:alert] = "Error: #{@image.errors.full_messages.join(",")}"
      end
    end

    redirect_to listing_path(params[:id])
  end

  # Set location
  def create_location_pref
    # if user signed up, save to db
    # if not, save to cookies

    if current_user.present?

      locations = Location.find(params[:prov]+params[:mun])

      if current_user.locations.length > 0
        current_user.locations.delete_all
      end
      current_user.locations << locations

      flash[:notice] = "Locations added successfully"
    end

    redirect_to root_path
  end

  private
  def sort_column
    %w[locations.denorm_name politicians.first_name politicians.last_name title_heirarchy num_comments].include?(params[:sort]) ? params[:sort] : "title_heirarchy"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
