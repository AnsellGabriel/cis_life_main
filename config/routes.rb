require 'sidekiq/web'

Rails.application.routes.draw do 
  resources :coop_agreements do
    resources :group_remits
  end
  
  resources :anniversaries, :agent_groups, :departments, :agents, :coop_users, :employees, :plans, :product_benefits, :proposals

  resources :agreement_benefits do
    get :selected, on: :member
  end

  resources :agreements 

  resources :group_remits do 
    get 'denied_members', to: 'denied_members#index'
    get 'download_csv', to: 'denied_members#download_csv'
    get :submit, on: :member
    get :renewal, on: :member
    resources :batches do
      collection do
        post :import
      end
      resources :batch_health_decs, as: 'health_declarations'
      resources :batch_dependents, as: 'dependents'
      resources :batch_beneficiaries, as: 'beneficiaries'
      resources :member_dependents do
        collection do
          post :create_beneficiary
          get :new_beneficiary
        end
      end
    end
  end

  resources :cooperatives do
    get :selected, on: :member
    resources :coop_branches
  end

  resources :members do
    
    collection do
      post :import
    end
  end

  resources :coop_members do
    get :selected, on: :member
  end

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  devise_scope :user do
    authenticated :user do
      # mount Sidekiq::Web in your Rails app
        root 'application#root', as: :authenticated_root
    end
  
    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end

  authenticate :user, -> (u) { u.admin? } do
    mount Sidekiq::Web => "/sidekiq"
  end
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
