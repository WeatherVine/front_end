require 'rails_helper'

RSpec.describe 'Discover Page', type: :feature do
  describe 'happy path' do
    it 'displays form with vintage and region' do
      stub_search_request
      visit discover_index_path

      within('.page-header') do
        expect(page).to have_content('Search For Wines')
      end

      within('#search-form') do
        fill_in 'Vintage', with: '2018'
        fill_in 'Location', with: 'napa'
        click_button 'Search'
      end

      expect(current_path).to eq(wines_search_path)
    end
  end

  describe 'sad path' do
    it 'shows flash message and (reloads) page if both query params are not entered' do
      visit discover_index_path

      within('#search-form') do
        fill_in 'Location', with: 'napa'
        click_button 'Search'
      end

      # Probably going to have to mock an api call here?
      expect(current_path).to eq(discover_index_path)
      expect(page).to have_selector('.flash-message')
      expect(page).to have_content('Please enter both a Location and a Vintage.')
    end
  end

  def stub_search_request
    full_url = "#{ENV['BACK_END_URL']}/api/v1/wines/search?location=napa&vintage=2018"
    sample_response = JSON.parse(File.read('spec/fixtures/search_results.json'), symbolize_names: true)

    stub_request(:get, full_url)
      .to_return(
        status: 200,
        body: sample_response.to_json,
        headers: {'Content-Type'=> 'application/json'}
      )
  end
end
