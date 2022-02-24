# frozen_string_literal: true

Rails.application.routes.draw do
  seems_rateable
  resources :categories
  resources :estimates
  resources :reviews, param: :review_id
  get 'about', to: 'pages#about'
  resources :tenants, param: :tenant_id
  resources :tenants, only: [] do
    resources :statuses, param: :status_id
    resources :statuses, only: [] do
      get 'products'
    end
    resources :products, param: :product_id do
      get 'send_product_card', to: 'products#send_product_card'
    end
    resources :product_statuses
    resources :user, only: [] do
      get 'products', to: 'tenant_member_products#index'
    end
    # get 'user_products', to: 'tenant_member_products#index'
    get 'contact'
    post 'send_email'
  end
  root to: 'home#index'
  get 'get_name', to: 'members#get_name'
  get 'demand_offer', to: 'home#contact'
  post 'search', to: 'tenants#search'
  resources :tenants, member: { rate: :put }
  # *MUST* come *BEFORE* devise's definitions (below)
  as :user do
    match '/user/confirmation' => 'confirmations#update', :via => :put, :as => :update_user_confirmation
  end

  devise_for :users, controllers: {
    registrations: 'registrations',
    confirmations: 'confirmations',
    sessions: 'milia/sessions',
    passwords: 'milia/passwords'
  }
  match '/plan/edit' => 'tenants#edit', via: :get, as: :edit_plan

  match '/plan/update' => 'tenants#update', via: %i[put patch], as: :update_plan
end
