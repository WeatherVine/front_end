require 'rails_helper'
require 'webmock/rspec'

RSpec.describe 'User Dashboard Spec', type: :feature do
  describe 'happy path' do
    before :each do
      stub_omniauth

      visit "/"

      click_button 'Register/Login with Google', match: :first

      json_response = File.read('spec/fixtures/users_wines.json')
      stub_request(:get,'https://weathervine-be.herokuapp.com/api/v1/users/#{current_user.id}/dashboard').to_return(status: 200, body: json_response)

    end

    describe 'as a user, when I vist my user dashboard' do

      it 'has a button to discover wines, a button to logout' do
        within(".nav-bar") do
          expect(page).to have_button("Discover Wines")
          expect(page).to have_button("Logout")
        end
      end

      # it 'has a section for favorite wines' do
      #   stub_request(:get, "https://weathervine-be.herokuapp.com/api/v1/users/#{current_user.id}/dashboard").
      #   to_return(status: 200, body: '{"data": [{"id": "1", "type": "favorite-wine", "attributes": {"api_id": "123", "name": "Duckborn Merlot", "comment": "those tanins tho"}}]}')
      #   expect(page).to have_content("Duckborn Merlot")
      # end
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
