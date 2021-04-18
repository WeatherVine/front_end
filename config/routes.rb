Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'welcome#index'
  get '/auth/google_oauth2/callback', to: 'sessions#create'
  get '/user/dashboard', to: 'dashboard#show'

  #discover
  resources :discover, only: [:index]

  #logout
  get '/logout', to: 'sessions#destroy'
  delete '/logout', to: 'sessions#destroy'
end
