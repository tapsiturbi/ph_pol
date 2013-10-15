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
end