Rails.application.routes.draw do
  resources :batch_dependents, :batches, :group_remits, :agreement_benefits, :anniversaries, :agreements, :agent_groups, :coop_branches, :cooperatives, :departments, :agents, :coop_users, :employees

  resources :coop_members do
    resources :coop_member_beneficiaries, path: 'beneficiaries', as: 'beneficiaries'
    resources :coop_member_dependents
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
