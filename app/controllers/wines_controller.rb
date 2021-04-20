class WinesController < ApplicationController
  before_action :authorized, only: [:show]

  def show
    @wine = WinesService.wine(params[:id])
  end

end
