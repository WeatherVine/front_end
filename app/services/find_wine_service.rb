class FindWineService

  def self.wines
    response = Farady.get("backend heroku endpoint #{current_user.id}")
    body = JSON.parse(response.body, symbolize_names: true)

    body[:data][0..2].map do |wine_info|
      Wine.new(wine_info[:attributes])
    end
  end

end
