require 'rails_helper'

RSpec.describe 'Search Results Page', type: :feature do
  describe 'happy path' do
    it 'displays search info' do
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
        save_and_open_page

        within('#search-results') do
          result_cards = page.all('.card')

          expect(result_cards.length).to eq(2)
          first = result_cards.first
          second = result_cards.last

          within(first) do
            expect(page).to have_content('Duckhorn The Discussion Red 2012')
            expect(page).to have_content('2018')
            expect(page).to have_content('Napa Valley')
          end

          within(first) do
            expect(page).to have_content('Duckhorn')
            expect(page).to have_content('2018')
            expect(page).to have_content('Napa Valley')
          end
        end
      end

      it 'each wine result also shows ___anything?___' do
        # TODO necessary? Or just lump in w/ previous
      end
    end
  end

  describe 'sad path' do
    xit 'enforces coexistence of query params' do

    end
  end

  def stub_search_request
    full_url = "#{ENV['BACK_END_URL']}/api/v1/wines/search?location=napa&vintage=2018"
    sample_response = JSON.parse(File.read('spec/fixtures/search_results.json'))

    stub_request(:get, full_url)
      .to_return(
        status: 200,
        body: sample_response.to_json,
        headers: {'Content-Type'=> 'application/json'}
      )
  end
end
