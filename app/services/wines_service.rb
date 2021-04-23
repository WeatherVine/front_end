class WinesService

  def self.wine(api_id)
    response = Faraday.get("#{ENV['BACK_END_URL']}/api/v1/wines/#{api_id}")
    body = JSON.parse(response.body, symbolize_names: true)
    self.format_wine(body)
  end

  private

  def self.format_wine(body)
    OpenStruct.new({
      api_id: body[:data][:attributes][:api_id],
      name: body[:data][:attributes][:name],
      area: body[:data][:attributes][:area],
      vintage: body[:data][:attributes][:vintage],
      eye: body[:data][:attributes][:eye],
      nose: body[:data][:attributes][:nose],
      mouth: body[:data][:attributes][:mouth],
      finish: body[:data][:attributes][:finish],
      overall: body[:data][:attributes][:overall],
      temp: body[:data][:attributes][:temp],
      precip: body[:data][:attributes][:precip],
      start_date: body[:data][:attributes][:start_date],
      end_date: body[:data][:attributes][:end_date]
    })
    end
  end
