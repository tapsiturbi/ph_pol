class UtilController < ApplicationController
  include ApplicationHelper
  
  # Returns JSON object of all municipals under a given ID
  def municipal
    # params[:id] is the location.id of the dropdown
    @municipals = Location.where("parent_id = ?", params[:id]).select("name, id").order("name asc")

    render :json => @municipals
  end

  # Performs a HTTP GET to a URL specified in the parameter 'u' and returns
  # a JSON object containing the following info:
  #     images - list of image urls parsed from external page
  #     title - title/subject of page
  #     desc - description
  #     link - link to external url
  # http://ph.news.yahoo.com/what-senator-binay-s-camp-thinks-of--black-nazarene--jokes-104813501.html
  def http_get
    url = params[:u]

    render :json => http_get_og_data(url)
  end
end
