Rails.application.routes.draw do
  get 'users/show', :as => '/user'
  post 'api_key/create' => 'users#create_api_key'
  post 'api_key/:key/delete' => 'users#delete_api_key'

  root 'data#index'

  resources :data

  get 'tags/:tags/:function' => 'tags#show'
  get 'tags/:tags' => 'tags#show'

  get '/auth/google_oauth2', :as => 'signin'
  match 'auth/:provider/callback' => 'sessions#create', :via => [:get, :post]
  match 'signout', to: 'sessions#destroy', :as => 'signout', :via => [:get, :post]
end
