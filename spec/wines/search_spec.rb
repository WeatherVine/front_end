require 'rails_helper'

RSpec.describe 'Search Results Page', type: :feature do
  describe 'happy path' do
    it 'displays search info' do
      VCR.use_cassette('napa_2018_search') do
        visit wines_search_path(location: 'napa', vintage: '2018')

        within('#search-info') do
          expect(page).to have_content('napa')
          expect(page).to have_content('2018')
        end
      end
    end

    describe 'search results' do
      it 'shows search results' do
        VCR.use_cassette('napa_2018_search') do
          visit wines_search_path(location: 'napa', vintage: '2018')

          within('#search-results') do
            result_cards = page.all('.card')

            expect(result_cards.length).to eq(5)
            first = result_cards.first
            last = result_cards.last

            within(first) do
              expect(page).to have_content('Bread & Butter Rosé 2018')
              expect(page).to have_content('2018')
              expect(page).to have_content('Napa Valley')
            end

            within(last) do
              expect(page).to have_content('Charles Krug Sauvignon Blanc')
              expect(page).to have_content('2018')
              expect(page).to have_content('Napa Valley')
            end
          end
        end
      end

      it 'wine names are links to their show page' do
        VCR.use_cassette('napa_2018_search') do
          visit wines_search_path(location: 'napa', vintage: '2018')

          expect(page.find("a[href='/wines/5eeacc5a1ed9f43f0db3a803']").text).to eq('Bread & Butter Rosé 2018')
          expect(page.find("a[href='/wines/5e32fac2a0d5a356656a6e99']").text).to eq('Charles Krug Sauvignon Blanc')
        end
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
end
