class Wines::SearchController < ApplicationController
  def show
    @info = fetch_data(params[:location], params[:vintage])
  end

  private

  def fetch_data(location, vintage)
    OpenStruct.new({
      search_params: search_params,
      search_results: fetch_search_results(location, vintage)
    })
  end

  def search_params
    params.permit(:location, :vintage).to_h.symbolize_keys
  end

  def fetch_search_results(location, vintage)
    response = back_end_connection.get("api/v1/wines/search?location=#{location}&vintage=#{vintage}")
    body = JSON.parse(response.body, symbolize_names: true)
    require "pry"; binding.pry
    {}
  end

  def back_end_connection
    @back_end_connection ||= Faraday.new(
      url: ENV['BACK_END_URL']
    )
  end
end
