Rails.application.routes.draw do
  root 'data#index'

  resources :data

  get 'tags/:tags/:function' => 'tags#show'
  get 'tags/:tags' => 'tags#show'

end
