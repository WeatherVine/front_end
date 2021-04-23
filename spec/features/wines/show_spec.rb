require 'rails_helper'
require 'webmock/rspec'

RSpec.describe 'Wine Show Page Spec', type: :feature do
  describe 'happy path' do
    # before :each do
    #   stub_omniauth

    #   @user = create(:user)
    #   allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

    #   single_wine_json_response = File.read('spec/fixtures/wine_show.json')
    #   wines_json_response = File.read('spec/fixtures/users_wines.json')

    #   stub_request(:get, "https://weathervine-be.herokuapp.com/api/v1/wines/546e64cf4c6458020000000d").
    #     with(
    #       headers: {
    #      'Accept'=>'*/*',
    #      'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
    #      'User-Agent'=>'Faraday v1.3.0'
    #       }).
    #     to_return(status: 200, body: "#{single_wine_json_response}", headers: {})

    #   stub_request(:get, "https://weathervine-be.herokuapp.com/api/v1/users/#{@user.id}/dashboard").
    #     with(
    #       headers: {
    #      'Accept'=>'*/*',
    #      'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
    #      'User-Agent'=>'Faraday v1.3.0'
    #       }).
    #     to_return(status: 200, body: "#{wines_json_response}", headers: {})

    #   stub_request(:post, "https://weathervine-be.herokuapp.com/api/v1/user/#{@user.id}/wines?comment=&name=Duckhorn%20Sauvignon%20Blanc&user_id=#{@user.id}&wine_id=546e64cf4c6458020000000d").
    #     with(
    #     headers: {
    #       'Accept'=>'*/*',
    #       'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
    #       'Content-Length'=>'0',
    #       'User-Agent'=>'Faraday v1.3.0'
    #       }).
    #       to_return(status: 200, body: "", headers: {})

    #   visit "/wines/546e64cf4c6458020000000d"
    # end

    it "shows page" do
      @user = create(:user, id: 111)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      VCR.use_cassette('wine_show_page') do
        visit "/wines/546e64cf4c6458020000000d"

        expect(page).to have_content("Duckhorn")
        expect(page).to have_content("Napa Valley")
        expect(page).to have_content("2013")
        # expect(page).to have_content("")
        expect(page).to have_content("Citrus, earthy aromas")
        expect(page).to have_content("Citrus, earthy flavours, fresh acidity, warm alcohol")
        expect(page).to have_content("Medium duration, good quality, middle peaktime")
        expect(page).to have_content("Subtle complexity, pleasant interest, harmonious balance")
        expect(page).to have_content("81")
        expect(page).to have_content("79.0")
        expect(page).to have_content("2012-01-01")
        expect(page).to have_content("2012-12-31")
        expect(page).to have_button("Add Wine to Favorite List")
      end
    end

    it "adds wine to favorite list" do
      VCR.turn_off!

      @user = create(:user, id: 111)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      # Request used to get intial state of user's favorite wines
      wines_json_response = File.read('spec/fixtures/users_wines.json')
      stub_request(:get, "#{ENV['BACK_END_URL']}/api/v1/users/#{@user.id}/dashboard").
        with(
          headers: {
         'Accept'=>'*/*',
         'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
         'User-Agent'=>'Faraday v1.3.0'
          }).
        to_return(status: 200, body: "#{wines_json_response}", headers: {})

      # Request to get the wine show page
      single_wine_json_response = File.read('spec/fixtures/wine_show.json')
      stub_request(:get, "#{ENV['BACK_END_URL']}/api/v1/wines/546e64cf4c6458020000000d").
        with(
          headers: {
         'Accept'=>'*/*',
         'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
         'User-Agent'=>'Faraday v1.3.0'
          }).
        to_return(status: 200, body: "#{single_wine_json_response}", headers: {})

      # Request to add to a user's favorite wines
      stub_request(:post, "#{ENV['BACK_END_URL']}/api/v1/users/#{@user.id}/wines?comment=&name=Duckhorn%20Sauvignon%20Blanc&user_id=#{@user.id}&wine_id=546e64cf4c6458020000000d").
        with(
        headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Content-Length'=>'0',
          'User-Agent'=>'Faraday v1.3.0'
          }).
          to_return(status: 200, body: "", headers: {})

      visit "/wines/546e64cf4c6458020000000d"

      # Request to get the _new_ (after having added a wine) user dashboard page
      added_favorite_wine_response = File.read('spec/fixtures/user_wines_after_create.json')
      stub_request(:get, "#{ENV['BACK_END_URL']}/api/v1/users/#{@user.id}/dashboard").
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

      VCR.turn_on!
    end
  end

  describe 'sad path' do
    it "gives a flash error if response is a 500" do
      VCR.turn_off!

      @user = create(:user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      single_wine_json_response = File.read('spec/fixtures/wine_show.json')

      stub_request(:get, "#{ENV['BACK_END_URL']}/api/v1/wines/546e64cf4c6458020000000d").
        with(
          headers: {
         'Accept'=>'*/*',
         'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
         'User-Agent'=>'Faraday v1.3.0'
          }).
        to_return(status: 200, body: "#{single_wine_json_response}", headers: {})

      stub_request(:get, "#{ENV['BACK_END_URL']}/api/v1/users/#{@user.id}/dashboard").
         with(
           headers: {
       	  'Accept'=>'*/*',
       	  'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	  'User-Agent'=>'Faraday v1.3.0'
           }).
         to_return(status: 200, body: "", headers: {})

      stub_request(:post, "#{ENV['BACK_END_URL']}/api/v1/users/#{@user.id}/wines?comment=&name=Duckhorn%20Sauvignon%20Blanc&user_id=#{@user.id}&wine_id=546e64cf4c6458020000000d").
        with(
        headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Content-Length'=>'0',
          'User-Agent'=>'Faraday v1.3.0'
          }).
          to_return(status: 500, body: "", headers: {})

      visit "/wines/546e64cf4c6458020000000d"

      click_button("Add Wine to Favorite List")
      expect(page).to have_current_path(wine_path("546e64cf4c6458020000000d"))
      expect(page).to have_content("We're sorry, there was an issue with your request")
      VCR.turn_on!
    end
  end
end
