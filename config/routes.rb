Rails.application.routes.draw do
  passwordless_for :users, at: '/', as: :auth

  resources :namespaces do
    resources :tallies
  end
  resources :users

  root "home#index"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
end
