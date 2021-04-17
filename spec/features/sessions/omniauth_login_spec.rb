require 'rails_helper'

RSpec.describe 'Login Sessions Spec', type: :feature do
  describe 'happy path' do
    it 'logs the user in with stubbing Google omniauth' do
      user_count = User.count
      expect(user_count).to eq(0)

      stub_omniauth
      user_count = User.count
      expect(user_count).to eq(0)

      visit "/"

      click_button 'Login'

      user_count = User.count
      expect(user_count).to eq(1)
      user = User.first

      expect(page).to have_content("Welcome, #{user.username}")
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
  end
end
