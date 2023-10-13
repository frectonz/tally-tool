# frozen_string_literal: true

Rails.application.routes.draw do
  resources :namespaces do
    resources :tallies
  end

  get "/register", to: "users#register_get"
  post "/register", to: "users#register_post"

  get "/verify/:token", to: "users#verify"

  get "/login", to: "users#login_get"
  post "/login", to: "users#login_post"

  post "/logout", to: "users#logout"

  root "home#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
end
