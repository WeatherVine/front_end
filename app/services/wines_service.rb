class WinesService

  def self.wine(api_id)
    response = Faraday.get("https://weathervine-be.herokuapp.com/api/v1/wines/#{api_id}")
    body = JSON.parse(response.body, symbolize_names: true)
    self.format_wine(body)
  end

  private

  def self.format_wine(body)
    OpenStruct.new({
                    api_id: body[:data][:api_id],
                    name: body[:data][:name],
                    area: body[:data][:area],
                    vintage: body[:data][:vintage],
                    eye: body[:data][:eye],
                    nose: body[:data][:nose],
                    mouth: body[:data][:mouth],
                    finish: body[:data][:finish],
                    overall: body[:data][:overall],
                    temp: body[:data][:temp],
                    precip: body[:data][:precip],
                    start_date: body[:data][:start_date],
                    end_date: body[:data][:end_date]
      })
    end
  end
