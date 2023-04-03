Rails.application.routes.draw do
  resources :coop_member_beneficiaries
  resources :coop_member_dependents
  resources :coop_members
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  
  resources :agent_groups
  resources :coop_branches
  resources :cooperatives
  resources :departments
  resources :agents
  resources :coops do
    root 'coops#home', as: :home
  end
  resources :employees

  devise_for :users, controllers: {
    registrations: 'users/registrations',
  }

  devise_scope :user do
    authenticated :user do
        root 'employees#index', as: :authenticated_root
    end
  
    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
