class UtilController < ApplicationController
  include ApplicationHelper
  
  # Returns JSON object of all municipals under a given ID
  def municipal
    # params[:id] is the location.id of the dropdown
    parent_ids = params[:id].include?(",") ? params[:id].split(",") : params[:id]
    @municipals = Location.where(parent_id: parent_ids).select("name, id, parent_id").order("name asc")

    render :json => @municipals
  end

  # Returns JSON object of all politicians under the given locations
  def politicians
    # params[:loc_ids] is the location.id of the dropdown
    municipal_ids = params[:loc_ids].include?(",") ? params[:loc_ids].split(",") : [params[:loc_ids]]

    @pol = Politician.joins(:careers).where("careers.location_id in (select id from locations where id in (:municipal_ids) UNION ALL select parent_id from locations where id in (:municipal_ids) )", { municipal_ids: municipal_ids }).select("politicians.id, politicians.first_name, politicians.last_name, careers.title, careers.location_id").select_title_heirarchy.order("careers.location_id, title_heirarchy")

    render :json => @pol
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
