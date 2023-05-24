Rails.application.routes.draw do
  resources :agent_groups
  resources :departments
  resources :agents
  resources :coop_users
  resources :employees
  resources :benefits
  resources :plans
  get 'pages/home'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :cooperatives do
    get :selected, on: :member
    resources :coop_branches
  end

  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  # Defines the root path route ("/")
  devise_scope :user do
    authenticated :user do
      root 'application#root', as: :authenticated_root
    end
  
    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end
end
