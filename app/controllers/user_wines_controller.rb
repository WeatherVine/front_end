class UserWinesController < ApplicationController

  def destroy
    Faraday.delete("https://weathervine-be.herokuapp.com/api/v1/user/#{current_user.id}/wines/#{params[:id]}")
    redirect_to user_dashboard_path
  end

  def create
    require "pry"; binding.pry
  end

end
