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
        # expect(page).to have_content("Duckborn Merlot")
        # expect(page).to have_content("Barefoot Cabernet Sauvignon")
        # expect(page).to have_content("Yellow Tail Pinot Noir")
        # expect(page).to have_content("Totes the best.")
        # expect(page).to have_content("It’s a'ight.")
        # expect(page).to have_content("OMG")
        expect(page).to have_content("My Favorite Wines")
        expect(page).to have_link("Duckhorn Merlot")
        expect(page).to have_link("Barefoot Cabernet Sauvignon")
        expect(page).to have_link("Yellow Tail Pinot Noir")
        expect("Duckhorn Merlot").to appear_before("Totes the best.")
        expect("Barefoot Cabernet Sauvignon").to appear_before("It’s a'ight.")
        expect("Yellow Tail Pinot Noir").to appear_before("OMG")
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
        save_and_open_page
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
