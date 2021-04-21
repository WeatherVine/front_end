require 'rails_helper'
require 'webmock/rspec'

RSpec.describe 'User Dashboard Spec', type: :feature do
  describe 'happy path' do
    before :each do
      stub_omniauth

      user = create(:user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      json_response = File.read('spec/fixtures/users_wines.json')

      stub_request(:get, "https://weathervine-be.herokuapp.com/api/v1/users/#{user.id}/dashboard").
        with(
          headers: {
         'Accept'=>'*/*',
         'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
         'User-Agent'=>'Faraday v1.3.0'
          }).
        to_return(status: 200, body: "#{json_response}", headers: {})

        visit user_dashboard_path

    end

    describe 'as a user, when I vist my user dashboard' do

      it 'has a button to discover wines, a button to logout' do
        within(".nav-bar") do
          expect(page).to have_button("Discover Wines")
          expect(page).to have_button("Logout")
        end
      end

      it "displays the user's favorite wine, and a comment on the wine" do
        expect(page).to have_content("My Favorite Wines")
        expect(page).to have_link("Duckhorn Merlot")
        expect(page).to have_link("Barefoot Cabernet Sauvignon")
        expect(page).to have_link("Yellow Tail Pinot Noir")
        expect("Duckhorn Merlot").to appear_before("Totes the best.")
        expect("Barefoot Cabernet Sauvignon").to appear_before("It’s a'ight.")
        expect("Yellow Tail Pinot Noir").to appear_before("OMG")
      end

      it 'clicking on the wine link takes you to the wine show page' do

        json_response_3 = File.read('spec/fixtures/wine_show.json')

        stub_request(:get, "https://weathervine-be.herokuapp.com/api/v1/wines/2345").
        with(
          headers: {
         'Accept'=>'*/*',
         'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
         'User-Agent'=>'Faraday v1.3.0'
          }).
        to_return(status: 200, body: "#{json_response_3}", headers: {})

        click_link("Barefoot Cabernet Sauvignon")
        expect(current_path).to eq(wine_path(2345))
        # "/wines/2345")
      end

      it "it has a button to delete the favorite user wine" do
        expect(page).to have_button('Unfavorite Duckhorn Merlot')
        expect(page).to have_button('Unfavorite Barefoot Cabernet Sauvignon')
        expect(page).to have_button('Unfavorite Yellow Tail Pinot Noir')
      end

      it "removes a wine from the favorite wines list when a user clicks the `unfavorite button`" do
        stub_omniauth

        user2 = create(:user, provider: "dog")
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user2)
        # json_response2 = File.read('spec/fixtures/user_wines_after_delete.json')
        stub_request(:delete, "https://weathervine-be.herokuapp.com/api/v1/user/#{user2.id}/wines/3456").
          with(
            headers: {
           'Accept'=>'*/*',
           'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
           'User-Agent'=>'Faraday v1.3.0'
            }).
          to_return(status: 200, body: "", headers: {})

        json_response2 = File.read('spec/fixtures/user_wines_after_delete.json')

        stub_request(:get, "https://weathervine-be.herokuapp.com/api/v1/users/#{user2.id}/dashboard").
          with(
            headers: {
           'Accept'=>'*/*',
           'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
           'User-Agent'=>'Faraday v1.3.0'
            }).
          to_return(status: 200, body: "#{json_response2}", headers: {})

        click_button("Unfavorite Yellow Tail Pinot Noir")
        expect(page).to have_current_path(user_dashboard_path)
        expect(page).to have_link("Duckhorn Merlot")
        expect(page).to have_link("Barefoot Cabernet Sauvignon")
        expect(page).to_not have_link("Yellow Tail Pinot Noir")

      end
    end
  end



  describe 'sad path' do
    before :each do
      stub_omniauth

      user = create(:user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      json_response = File.read('spec/fixtures/users_wines.json')

      stub_request(:get, "https://weathervine-be.herokuapp.com/api/v1/users/#{user.id}/dashboard").
        with(
          headers: {
         'Accept'=>'*/*',
         'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
         'User-Agent'=>'Faraday v1.3.0'
          }).
        to_return(status: 200, body: "", headers: {})

        visit user_dashboard_path

    end

    describe 'as a user, when I vist my user dashboard' do

      it 'has a button to discover wines, a button to logout' do
        within(".nav-bar") do
          expect(page).to have_button("Discover Wines")
          expect(page).to have_button("Logout")
        end
      end

      it "alerts user if they do not have any favorite wines" do
        expect(page).to have_content("You don't have any favorite wines yet!")
      end
    end
  end
end

    # it 'logs a returning user in via google mock' do
    #   stub_omniauth
    #   user = create(:omniauth_mock_user)
    #   user_count = User.count
    #   expect(user_count).to eq(1)
    #
    #   visit root_path
    #
    #   click_link 'Log in with Google'
    #
    #   user_count = User.count
    #   expect(user_count).to eq(1)
    #
    #   expect(current_path).to eq(dashboard_path)
    #   expect(page).to have_content("Welcome back, #{user.username}")
    # end
