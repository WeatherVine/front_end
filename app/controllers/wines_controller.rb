class WinesController < ApplicationController
  before_action :authorized, only: [:show]

  def show
    @wine = WinesService.wine(params[:id])
    @wines_api_ids = FindWineService.wine_api_ids(current_user.id)
  end

end
