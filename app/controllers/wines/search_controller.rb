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
    body = send_search_query(location, vintage)
    generate_ostructs_from(body)
  end

  def back_end_connection
    @back_end_connection ||= Faraday.new(
      url: ENV['BACK_END_URL']
    )
  end

  def send_search_query(location, vintage)
    response = back_end_connection.get("api/v1/wines/search?location=#{location}&vintage=#{vintage}")
    JSON.parse(response.body, symbolize_names: true)
  end

  def generate_ostructs_from(response_body)
    response_body[:data].map do |search_result|
      ostruct_from(search_result[:attributes])
    end
  end

  def ostruct_from(search_result)
    OpenStruct.new({
      name: search_result[:name],
      api_id: search_result[:api_id],
      vintage: search_result[:vintage],
      location: search_result[:location]
    })
  end
end