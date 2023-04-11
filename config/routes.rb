require 'sidekiq/web'
require 'sidekiq-scheduler/web'
require_relative '../lib/middlewares/static_token_auth'

Rails.application.routes.draw do
  get 'users/admin/v1/users'

  Sidekiq::Web.use StaticTokenAuth
  mount Sidekiq::Web => '/sidekiq/:token'
  mount_devise_token_auth_for 'User', at: 'auth/v1/user'

  namespace :admin do
    namespace :v1 do
      get "home" => "home#index"
      resources :categories
      resources :products
      resources :coupons
      resources :system_requirements
      resources :users
      resources :orders, only: [:index, :show]
      resources :games, only: [], shallow: true do
        resources :licenses
      end

      namespace :dashboard do
        resources :summaries, only: :index
        resources :top_five_products, only: :index
        resources :sales_ranges, only: :index
      end
    end
  end

  namespace :storefront do
    namespace :v1 do  
      get "home" => "home#index"
      resources :products, only: [:index, :show]
      resources :categories, only: :index
      resources :wish_items, only: [:index, :create, :destroy]
      post "/coupons/:coupon_code/validations", to: "coupon_validations#create"
      resources :checkouts, only: :create
      resources :orders, only: [:index, :show]
      resources :games, only: :index
    end
  end

  namespace :juno do
    namespace :v1 do
      resources :payment_confirmations, only: :create
    end
  end
end