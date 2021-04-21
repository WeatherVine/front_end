require 'rails_helper'

RSpec.describe 'Search Results Page', type: :feature do
  describe 'happy path' do
    it 'displays search info' do
      stub_search_request
      visit wines_search_path(location: 'napa', vintage: '2018')

      within('#search-info') do
        expect(page).to have_content('napa')
        expect(page).to have_content('2018')
      end
    end

    describe 'search results' do
      it 'shows search results' do
        stub_search_request
        visit wines_search_path(location: 'napa', vintage: '2018')

        within('#search-results') do
          result_cards = page.all('.card')

          expect(result_cards.length).to eq(2)
          first = result_cards.first
          second = result_cards.last

          within(first) do
            expect(page).to have_content(@first_result[:name])
            expect(page).to have_content(@first_result[:vintage])
            expect(page).to have_content(@first_result[:location])
          end

          within(second) do
            expect(page).to have_content(@last_result[:name])
            expect(page).to have_content(@last_result[:vintage])
            expect(page).to have_content(@last_result[:location])
          end
        end
      end

      it 'wine names are links to their show page' do
        stub_search_request
        visit wines_search_path(location: 'napa', vintage: '2018')

        expect(page.find("a[href='/wines/#{@first_result[:api_id]}']").text).to eq(@first_result[:name])
        expect(page.find("a[href='/wines/#{@last_result[:api_id]}']").text).to eq(@last_result[:name])
      end
    end
  end

  describe 'sad path' do
    it 'redirects back to discover page w/ a flash message if any param is missing' do
      visit wines_search_path(vintage: '2018', location: '')

      expect(current_path).to eq(discover_index_path)
      expect(page).to have_selector('.flash-message')
      expect(page).to have_content('Please enter both a Location and a Vintage.')
    end
  end

  def stub_search_request
    full_url = "#{ENV['BACK_END_URL']}/api/v1/wines/search?location=napa&vintage=2018"
    sample_response = JSON.parse(File.read('spec/fixtures/search_results.json'), symbolize_names: true)

    # Save the results so we can use them in test expectations
    @first_result = {
      name: sample_response[:data][0][:attributes][:name],
      api_id: sample_response[:data][0][:attributes][:api_id],
      vintage: sample_response[:data][0][:attributes][:vintage],
      location: sample_response[:data][0][:attributes][:location],
    }
    @last_result = {
      name: sample_response[:data][1][:attributes][:name],
      api_id: sample_response[:data][1][:attributes][:api_id],
      vintage: sample_response[:data][1][:attributes][:vintage],
      location: sample_response[:data][1][:attributes][:location],
    }

    # Webmock the request
    stub_request(:get, full_url)
      .to_return(
        status: 200,
        body: sample_response.to_json,
        headers: {'Content-Type'=> 'application/json'}
      )
  end
end
