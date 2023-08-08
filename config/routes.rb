Rails.application.routes.draw do
  root   "static_pages#home"
  get    "/help",    to: "static_pages#help"
  get    "/about",   to: "static_pages#about"
  get    "/terms",   to: "static_pages#terms"
  get    "/privacy", to: "static_pages#privacy"
  get    "/company", to: "static_pages#company"
  get    "/jobs",    to: "static_pages#jobs"
  get    "/signup",  to: "users#new"
  get    "/login",   to: "sessions#new"
  post   "/login",   to: "sessions#create"
  delete "/logout",  to: "sessions#destroy"

  get    "/contact",         to: "contacts#index"
  post   "/contact/confirm", to: "contacts#confirm"
  post   "/contact/done",    to: "contacts#done"

  post   "/google_login_api/callback", to: "google_login_api#callback"

  resources :users, except: [:index] do
    member do
      get :following, :followers
    end
  end

  resources :posts do
    collection do
      get :draft
    end
  end

  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :relationships,       only: [:create, :destroy]
  resources :stocks,              only: [:index, :create, :destroy]
  resources :categories,          only: [:index, :new, :create]
end
