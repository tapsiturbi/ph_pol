class UtilController < ApplicationController
  def municipal
    # params[:id] is the location.id of the dropdown
    @municipals = Location.where("parent_id = ?", params[:id]).select("name, id").order("name asc")

    render :json => @municipals
  end
end
