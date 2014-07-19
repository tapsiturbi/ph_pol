class Users::ProfileController < ApplicationController
  def edit
    @user = current_user
  end

  def show
    @user = User.find(params[:id])

    #@comments = Career.with_loc_and_pol.with_comments_and_user
    #@comments = Comment.joins(:user).where("users.id = ?", params[:id])

    @careers = Career.with_comments_from_user(params[:id])
  end

  def update
    @user = current_user
    #puts params[:user].permit(:avatar, :email, :first_name, :last_name)

    if @user.update(params[:user].permit(:avatar, :email, :first_name, :last_name))
      redirect_to root_path
    else
      render "edit"
    end
  end

  # Page that displays regions to 'tag' for the current user
  def regions
    #@nationwide = Location.get_nationwide
    #@provinces = Location.provinces.where('id != ?', @nationwide.id).collect {|p| [p.name.capitalize, p.id]}
    @regions = Region.order('region_iso').all
    #@user_regions = User.find(current_user.id).regions.pluck(:region_iso)
    @user_regions = {}
  end
end