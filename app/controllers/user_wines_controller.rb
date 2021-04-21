class UserWinesController < ApplicationController

  def destroy
    resp = Faraday.delete("https://weathervine-be.herokuapp.com/api/v1/user/#{current_user.id}/wines/#{params[:id]}") do |req|
      req.params['user_id'] = current_user.id
      req.params['wine_id'] = params[:id]
    end
    
    if resp.status == 200
      redirect_to user_dashboard_path
    else
      flash[:message] = "We're sorry, there was an issue with your request"
      redirect_to user_dashboard_path
    end
  end

  def create
    resp = Faraday.post("https://weathervine-be.herokuapp.com/api/v1/user/#{current_user.id}/wines") do |req|
      req.params['comment'] = params[:comment]
      req.params['wine_id'] = params[:api_id]
      req.params['name'] = params[:name]
      req.params['user_id'] = current_user.id
    end

    if resp.status == 200
      redirect_to user_dashboard_path
    else
      flash[:message] = "We're sorry, there was an issue with your request"
      redirect_to "/wines/#{params[:api_id]}"
    end
  end
end
