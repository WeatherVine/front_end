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

      stub_request(:get, %r{\Ahttps://weathervine-be.herokuapp.com/api/v1/users/\d+/dashboard\z}).
      with(
        headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent'=>'Faraday v1.3.0'
          }).
          to_return(status: 200, body: "", headers: {})

      click_button 'Register/Login with Google', match: :first

      # require "pry"; binding.pry

      # login_response = File.read('spec/fixtures/login.json')


      user_count = User.count
      expect(user_count).to eq(1)
      user = User.first
      expect(page).to have_content("Welcome, #{user.username}")
    end

    it 'can log a user out' do
      stub_omniauth

      visit "/"

      stub_request(:get, %r{\Ahttps://weathervine-be.herokuapp.com/api/v1/users/\d+/dashboard\z}).
      with(
        headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent'=>'Faraday v1.3.0'
          }).
          to_return(status: 200, body: "", headers: {})

      click_button 'Register/Login with Google', match: :first
      click_button 'Logout'
      expect(page).to have_current_path(root_path)
      expect(page).to have_content("You have been logged out")
    end

  end
end
