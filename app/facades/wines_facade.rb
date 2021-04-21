class WinesFacade

  # def conn
  #   conn = Faraday.new("https://weathervine-be.herokuapp.com/api/v1/")
  # end

  def self.return(api_id, user_id)
    wine = WinesService.wine(api_id)
    wines_api_ids = FindWineService.wine_api_ids(user_id)
    [wine, wines_api_ids]
  end

  # def wine_call
  # end
  #
  # def weather_call
  # end

  # def self.return
  #   OpenStruct.new({
  #                   api_id: data[:api_id],
  #                   name: data[:name],
  #                   area: data[:area],
  #                   vintage: data[:vintage],
  #                   eye: data[:eye],
  #                   nose: data[:nose],
  #                   mouth: data[:mouth],
  #                   finish: data[:finish],
  #                   overall: data[:overall],
  #                   temp: data[:temp],
  #                   precip: data[:precip],
  #                   start_date: start_date[:start_date],
  #                   end_date: end_date[:end_date]
  #     })
  # end

end
