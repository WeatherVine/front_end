Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'welcome#index'
  get '/auth/google_oauth2/callback', to: 'sessions#create'
  get '/user/dashboard', to: 'dashboard#show'

  # Discover
  resources :discover, only: [:index]

  # Logout
  get '/logout', to: 'sessions#destroy'
  delete '/logout', to: 'sessions#destroy'

  # Search Results
  get '/wines/search', to: 'wines/search#show'

  # Wines
  get '/wines/:id', to: 'wines#show', as: 'wine'

  # User Wines
  resources :user_wines, only: [:create, :destroy]
end
