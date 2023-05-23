Rails.application.routes.draw do 
  resources :anniversaries, :agent_groups, :departments, :agents, :coop_users, :employees, :plans, :product_benefits, :proposals

  resources :agreement_benefits do
    get :selected, on: :member
  end

  resources :agreements do
    resources :group_remits
  end

  resources :group_remits do 
    get :submit, on: :member
    collection do
      post 'create_single'
    end
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
