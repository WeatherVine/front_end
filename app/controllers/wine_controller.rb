class WineController < ApplicationController
  before_action :authorized, only: [:show]

  def show
    @wine = ShowWine.find_wine(params["api_id"])
  end

end
