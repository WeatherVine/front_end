require 'rails_helper'
require 'webmock/rspec'

RSpec.describe 'Wine Show Page Spec', type: :feature do
  describe 'happy path' do
    before :each do
      stub_omniauth

      "https://weathervine-be.herokuapp.com/api/v1/wines/:api_id"

      user = create(:user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      json_response = File.read('spec/fixtures/wine_show.json')

      stub_request(:get, "https://weathervine-be.herokuapp.com/api/v1/wines/546e64cf4c6458020000000d").
        with(
          headers: {
         'Accept'=>'*/*',
         'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
         'User-Agent'=>'Faraday v1.3.0'
          }).
        to_return(status: 200, body: "#{json_response}", headers: {})

      visit "/wines/546e64cf4c6458020000000d"
    end

    it "shows page" do
      expect(page).to have_content("Duckhorn Sauvignon Blanc")
      expect(page).to have_content("Napa Valley")
      expect(page).to have_content("2018")
      expect(page).to have_content("eagle")
      expect(page).to have_content("Citrus, Earthy aromas")
      expect(page).to have_content("Citrus, Earthy flavours, Fresh acidity, Warm alcohol")
      expect(page).to have_content("Medium duration, Good quality, Middle peaktime")
      expect(page).to have_content("Subtle complexity, Pleasant interest, Harmonious balance")
      expect(page).to have_content("75")
      expect(page).to have_content("100")
      save_and_open_page
    end
  end
end
