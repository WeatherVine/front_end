class SessionsController < ApplicationController
  def create
    user = User.create_from_omniauth(auth)
    require "pry"; binding.pry
    session[:user_id] = user.id
    redirect_to user_dashboard_path
  end

  def destroy
    session[:user_id] = nil
    flash[:message] = 'You have been logged out'
    redirect_to root_path
  end

  private

  def auth
    request.env['omniauth.auth']
  end
end
