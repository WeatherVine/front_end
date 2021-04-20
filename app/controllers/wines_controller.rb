class WinesController < ApplicationController
  before_action :authorized, only: [:show]

  def show
  end

end
