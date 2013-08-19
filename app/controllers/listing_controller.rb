class ListingController < ApplicationController
  helper_method :sort_column, :sort_direction

  # Controller that displays all Politicians
  def index
    params[:page] ||= 1

    # get Politicians based on their current career
    @careers = Career.includes(:location, :politician).where("end_date is null").search(params[:search]).order(sort_column + " " + sort_direction).paginate(:per_page => 25, :page => params[:page])

  end

  private
  def sort_column
    %w[locations.denorm_name politicians.first_name politicians.last_name title].include?(params[:sort]) ? params[:sort] : "title"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
