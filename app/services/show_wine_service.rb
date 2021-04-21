# class ShowWineService
#
#   def self.find_wine(api_id)
#     response = Faraday.get("https://weathervine-be.herokuapp.com/api/v1/wines/#{api_id}")
#     body = JSON.parse(response.body, symbolize_names: true)
#     self.format_wine(body)
#
#   end
#
#   private
#
#   def self.format_wine(body)
#     body[:data].map do |wine_data|
#       attributes = wine_data[:attributes]
#       OpenStruct.new({
#                       api_id: attributes[:api_id],
#                       name: attributes[:name],
#                       comment: attributes[:comment]
#         })
#     end
#   end
#
# end
