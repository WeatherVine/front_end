require 'rails_helper'
require 'webmock/rspec'

RSpec.describe 'Wine Show Page Spec', type: :feature do
  describe 'happy path' do
    before :each do
      stub_omniauth

      "https://weathervine-be.herokuapp.com/api/v1/wines/:api_id"

      @user = create(:user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      single_wine_json_response = File.read('spec/fixtures/wine_show.json')
      wines_json_response = File.read('spec/fixtures/users_wines.json')

      stub_request(:get, "https://weathervine-be.herokuapp.com/api/v1/wines/546e64cf4c6458020000000d").
        with(
          headers: {
         'Accept'=>'*/*',
         'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
         'User-Agent'=>'Faraday v1.3.0'
          }).
        to_return(status: 200, body: "#{single_wine_json_response}", headers: {})

        stub_request(:get, "https://weathervine-be.herokuapp.com/api/v1/users/#{@user.id}/dashboard").
          with(
            headers: {
           'Accept'=>'*/*',
           'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
           'User-Agent'=>'Faraday v1.3.0'
            }).
          to_return(status: 200, body: "#{wines_json_response}", headers: {})

        stub_request(:post, "https://weathervine-be.herokuapp.com/api/v1/user/#{@user.id}/wines?comment=&name=Duckhorn%20Sauvignon%20Blanc&user_id=#{@user.id}&wine_id=546e64cf4c6458020000000d").
          with(
          headers: {
            'Accept'=>'*/*',
            'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Content-Length'=>'0',
            'User-Agent'=>'Faraday v1.3.0'
            }).
            to_return(status: 200, body: "", headers: {})

      visit "/wines/546e64cf4c6458020000000d"
    end

    it "shows page" do
      expect(page).to have_content("Duckhorn Sauvignon Blanc")
      expect(page).to have_content("Napa Valley")
      expect(page).to have_content("2018")
      expect(page).to have_content("Eagle")
      expect(page).to have_content("Citrus, earthy aromas")
      expect(page).to have_content("Citrus, earthy flavours, fresh acidity, warm alcohol")
      expect(page).to have_content("Medium duration, good quality, middle peaktime")
      expect(page).to have_content("Subtle complexity, pleasant interest, harmonious balance")
      expect(page).to have_content("75")
      expect(page).to have_content("100")
      expect(page).to have_button("Add Wine to Favorite List")
    end

    it "adds wine to favorite list" do
      added_favorite_wine_response = File.read('spec/fixtures/user_wines_after_create.json')

      stub_request(:get, "https://weathervine-be.herokuapp.com/api/v1/users/#{@user.id}/dashboard").
        with(
          headers: {
         'Accept'=>'*/*',
         'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
         'User-Agent'=>'Faraday v1.3.0'
          }).
        to_return(status: 200, body: "#{added_favorite_wine_response}", headers: {})

      click_button("Add Wine to Favorite List")
      expect(page).to have_current_path(user_dashboard_path)
      expect(page).to have_content("My Favorite Wines")
      expect(page).to have_link("Duckhorn Merlot")
      expect(page).to have_link("Barefoot Cabernet Sauvignon")
      expect(page).to have_link("Yellow Tail Pinot Noir")
      expect(page).to have_link("Duckhorn Sauvignon Blanc")
      expect("Duckhorn Merlot").to appear_before("Totes the best.")
      expect("Barefoot Cabernet Sauvignon").to appear_before("It’s a'ight.")
      expect("Yellow Tail Pinot Noir").to appear_before("OMG")
      expect("Duckhorn Sauvignon Blanc").to appear_before("Rose all day")
    end
  end
end
