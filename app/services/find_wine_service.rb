class FindWineService

  def self.wines(user_id)
    response = Faraday.get("https://weathervine-be.herokuapp.com/api/v1/users/#{user_id}/dashboard")
    body = JSON.parse(response.body, symbolize_names: true)
    wines = body[:data][0..2].map do |wine_info|
      Wine.new(wine_info[:attributes])
    end
  end

end
