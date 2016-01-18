Rails.application.routes.draw do
  root 'data#index'

  resources :data

  get 'tags/:tags/:function' => 'tags#show'
  get 'tags/:tags' => 'tags#show'

  get '/auth/google_oauth2', :as => 'signin'
  match 'auth/:provider/callback' => 'sessions#create', :via => [:get, :post]
  match 'signout', to: 'sessions#destroy', :as => 'signout', :via => [:get, :post]
end
