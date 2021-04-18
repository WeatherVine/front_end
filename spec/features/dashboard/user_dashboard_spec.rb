require 'rails_helper'

RSpec.describe 'User Dashboard Spec', type: :feature do
  describe 'happy path' do
    before :each do
      stub_omniauth

      visit "/"

      click_button 'Register/Login with Google', match: :first
    end

      describe 'as a user, when I vist my user dashboard' do

        it 'has a button to discover wines, a button to logout, and a section for my favorite wines' do
          within(".nav-bar") do
            expect(page).to have_button("Discover Wines")
            expect(page).to have_button("Logout")
          end
          # expect(page).to have_content("My Favorite Wines")

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
