Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  
  root 'products#new'

  resources :products, only: [:new, :create, :index] do
    collection do
      get 'filter', to: 'products#filter', as: :filter
    end
  end
end
