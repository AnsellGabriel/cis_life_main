Rails.application.routes.draw do
  resources :agent_groups
  resources :coop_branches
  resources :cooperatives
  resources :departments
  resources :agents
  resources :coops
  resources :employees

  devise_for :users
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
