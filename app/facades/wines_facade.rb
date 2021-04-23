class WinesFacade
  def self.return(api_id, user_id)
    wine = WinesService.wine(api_id)
    wines_api_ids = FindWineService.wine_api_ids(user_id)
    [wine, wines_api_ids]
  end
end
