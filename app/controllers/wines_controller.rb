class WinesController < ApplicationController
  before_action :authorized, only: [:show]

  def show
    @wine = WinesFacade.return(params[:id], current_user.id)
    # require "pry"; binding.pry
    # @wine = WinesService.wine(params[:id])
    # @wines_api_ids = FindWineService.wine_api_ids(current_user.id)
  end

end
