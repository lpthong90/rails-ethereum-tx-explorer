Rails.application.routes.draw do
  root "home#index"

  get 'home/index', to: "home#index", as: "home"

  get 'blocks', to: "blocks#index", as: "blocks"
  get 'block/:hash', to: "blocks#show", as: "show_block"

  get 'txs', to: 'transactions#index', as: "txs"
  get 'tx/:hash', to: 'transactions#show', as: "show_tx"

  get 'address/:address', to: 'addresses#show', as: "show_address"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
