class UsersController < ApplicationController
  before_action :require_login
  before_action :set_user, only: [:edit, :profile, :update, :destroy]
  def index
    if params[:id]
      @users = User.where('id < ?', params[:id]).limit(2)
    else
      @users = User.all.limit(2)
    end

    respond_to do |format|
      format.html
      format.js
    end

  end

  def edit
  end

  def update
    if @user.update(user_params)
      respond_to do |format|
        format.html { redirect_to users_path }
      end
    else
      redirect_to edit_user_path(@user)
    end
  end

  def destroy
    if @user.destroy
      session[:user_id] = nil
      session[:omniauth] = nil
      redirect_to root_path
    else
      redirect_to edit_user_path(@user)
    end
  end

  def profile
  end

  def matches
    #gets all friendships and grabs all friends that have active state
    @matches = current_user.friendships.where(state: "active").map(&:friend) + current_user.inverse_friendships.where(state: "active").map(&:user)
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:interest, :bio, :avatar, :location, :date_of_birth)
  end
end
