class UsersController < ApplicationController
  before_action :require_login
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

  def profile
  end

  def matches
    #gets all friendships and grabs all friends that have active state
    @matches = current_user.friendships.where(state: "active").map(&:friend) + current_user.inverse_friendships.where(state: "active").map(&:user)
  end
end
