Rails.application.routes.draw do
  resources :namespaces do
    resources :tallies
  end

  get "/register", to: "users#register"
  post "/register", to: "users#create"

  root "home#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
end
