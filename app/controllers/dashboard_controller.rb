class DashboardController < ApplicationController
  before_action :authorized, only: [:show]
  before_action :current_user, only: [:show]

  def show
    @wines = FindWineService.wines(current_user.id)
  end

  # private

  # def find_wines
    #@wines = FindWineService.wines
  # end
end
