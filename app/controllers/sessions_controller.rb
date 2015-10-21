class SessionsController < ApplicationController

  def create
    auth = request.env["omniauth.auth"]                     #request response assigned to auth
    session[:omniauth] = auth                               #pick up that value and store it in session
    user = User.sign_in_from_facebook(auth)                 #create User passing the callback response (or locate user)
    session[:user_id] = user.id                            #create session
    redirect_to root_url, notice: "Signed In Successfully"  #redirect with message
  end

  def destroy
    session[:user_id] = nil
    session[:omniauth] = nil
    redirect_to root_url, notice: "Signed Out Successfully"
  end

end