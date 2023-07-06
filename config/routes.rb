Rails.application.routes.draw do
  get 'google_login_api/callback'
  root   "static_pages#home"
  get    "/help",    to: "static_pages#help"
  get    "/about",   to: "static_pages#about"
  get    "/terms",   to: "static_pages#terms"
  get    "/privacy", to: "static_pages#privacy"
  get    "/contact", to: "static_pages#contact"
  get    "/signup",  to: "users#new"
  get    "/login",   to: "sessions#new"
  post   "/login",   to: "sessions#create"
  delete "/logout",  to: "sessions#destroy"
  post   "/google_login_api/callback", to: "google_login_api#callback"
  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :posts
  resources :relationships,       only: [:create, :destroy]
end
