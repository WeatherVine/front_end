require 'rails_helper'

RSpec.describe 'Welcome Page', type: :feature do
  describe 'happy path' do
    it 'displays weather vine welcome page with info and login/register via google' do
      visit root_path

      expect(page).to have_content("Welcome to Weather Vine!")
      expect(page).to have_css('.app-info')
      within('.app-info') do
        expect(page).to have_content("Learn all about Weather Vine here")
      end

      expect(page).to have_css(".nav-bar")
      within('.nav-bar') do
        expect(page).to have_button("Register/Login with Google")
      end
    end
  end
end
