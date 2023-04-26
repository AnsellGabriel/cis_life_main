Rails.application.routes.draw do 
  resources :batch_dependents, :anniversaries, :agreements, :agent_groups, :departments, :agents, :coop_users, :employees

  resources :agreement_benefits do
    get :selected, on: :member
  end

  resources :group_remits do 
    resources :batches
  end

  resources :cooperatives do
    get :selected, on: :member
    resources :coop_branches
  end

  resources :members do
    resources :member_dependents, path: 'dependents', as: 'dependents'
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
        root 'application#root', as: :authenticated_root
    end
  
    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
