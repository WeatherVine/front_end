class DashboardController < ApplicationController
  before_action :current_user, only: [:show]

  def show
    @wines = FindWineService.wines
    require "pry"; binding.pry
  end

  # private

  # def find_wines
    #@wines = FindWineService.wines
  # end
end
