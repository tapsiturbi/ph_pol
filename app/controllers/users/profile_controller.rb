class Users::ProfileController < ApplicationController
  def edit
    @user = current_user
  end

  def save
    @user = current_user
    puts params[:user].permit(:avatar, :email, :first_name, :last_name)

    if @user.update(params[:user].permit(:avatar, :email, :first_name, :last_name))
      redirect_to root_path
    else
      render "edit"
    end
  end
end