class FindWineService
  def self.wines(user_id)
    response = Faraday.get("#{ENV['BACK_END_URL']}/api/v1/users/#{user_id}/dashboard")
    if response.body == ""
      nil
    else
      body = JSON.parse(response.body, symbolize_names: true)
      self.format_wines(body)
    end
  end

  def self.wine_api_ids(user_id)
    wines = self.wines(user_id)
    if wines
      wines.map do |wine|
        wine.api_id
      end
    else
      []
    end
  end

  private

  def self.format_wines(body)
    body[:data].map do |wine_data|
      attributes = wine_data[:attributes]
      OpenStruct.new({
                      api_id: attributes[:api_id],
                      name: attributes[:name],
                      comment: attributes[:comment]
        })
    end
  end

end
