class SessionsController < ApplicationController
  def create
    user = User.create_from_omniauth(auth)

    session[:user_id] = user.id
    redirect_to user_dashboard_path
  end

  private

  def auth
    request.env['omniauth.auth']
  end
end
