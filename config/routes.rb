require 'sidekiq/web'

Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/super-admin', as: 'rails_admin'

  devise_for :janitors, path: '', controllers: {
    registrations: 'janitors/registrations',
    sessions: 'janitors/sessions',
    passwords: 'janitors/passwords',
    confirmations: 'janitors/confirmations'
  }
  devise_for :inspectors, path: 'audit', controllers: {
    registrations: 'inspectors/registrations',
    sessions: 'inspectors/sessions',
    passwords: 'inspectors/passwords'
  }

  devise_for :admins, controllers: {
    sessions: 'admins/sessions'
  }

  authenticate :admin do
    mount Sidekiq::Web, at: '/sidekiq'
  end

  resources :facilities
  resources :products, only: %i[index show]

  get 'policies/terms'
  get 'policies/privacy'

  root to: 'site#home'

  post '/direct-upload', to: 'direct_upload#create'

  # Janitors namespace
  scope module: 'janitors', as: 'janitors' do
    resources :after_signup
    resources :requests
    resources :create_request do
      get :cancel, on: :collection
      get :draft, on: :collection
    end

    get '/dashboard', to: 'dashboard#home'
    get '/dashboard/profile', to: 'dashboard#profile'
    get '/dashboard/help', to: 'dashboard#help'
    get '/dashboard/terms', to: 'dashboard#terms'
    get '/dashboard/privacy', to: 'dashboard#privacy'
    
    root to: 'dashboard#home'
  end

  resources :janitors, only: %i[edit update], path: '/client' do
    collection do
      get :completion
    end

    member do
      get :edit_password
      put :update_password
    end
  end

  # Inspectors namespace
  scope module: 'inspectors', path: 'audit', as: 'inspectors' do
    resources :after_signup
    resources :reports
    resources :create_report do
      get :completion, on: :collection
      get :saved_as_draft, on: :collection
      get :cancel, on: :collection
    end

    get '/dashboard', to: 'dashboard#home'
    get '/dashboard/profile', to: 'dashboard#profile'
    get '/dashboard/help', to: 'dashboard#help'
    get '/dashboard/terms', to: 'dashboard#terms'
    get '/dashboard/privacy', to: 'dashboard#privacy'

    root to: 'dashboard#home'
  end

  resources :inspectors, only: %i[edit update], path: '/audit' do
    collection do
      get :completion
    end

    member do
      get :edit_password
      put :update_password
    end
  end

  # Admins namespace
  namespace :admins do
    get '/dashboard', to: 'dashboard#home'

    resources :facilities
    resources :inspectors
    resources :products

    resources :reports, only: %i[index show destroy] do
      member do
        put :complete
        put :draft
      end
    end

    resources :requests, only: %i[index show destroy] do
      member do
        put :complete
      end
    end
    root to: 'requests#index'
  end

  get 'public/request/:id' ,to: 'admins/requests#show_public', as: 'public_request_page'
  get 'public/report/:id' ,to: 'admins/reports#show_public', as: 'public_report_page'

  resources :admins, path: 'admins/manage_admins'
    
end
