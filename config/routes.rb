
require 'sidekiq/web'

Rails.application.routes.draw do 
 
  resources :anniversaries, :agent_groups, :departments, :agents, :coop_users, :employees, :plans, :product_benefits, :proposals

  resources :agreement_benefits do
    get :selected, on: :member
  end

  resources :agreements do
    get :show_details, on: :member
  end

  # resources :agreement_benefits
  # resources :plans
  # resources :agreements
  # resources :cooperatives
  resources :coop_types
  resources :geo_barangays
  resources :geo_municipalities
  resources :geo_provinces
  resources :geo_regions
  # resources :agent_groups
  # resources :departments
  # resources :agents
  # resources :coop_users
  # resources :employees
  resources :benefits
  # get 'pages/home'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  #* Coop Module Routes
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
    get :member_agreements, on: :member
  end

  resources :group_remits do 
    get 'denied_members', to: 'denied_members#index'
    get 'download_csv', to: 'denied_members#download_csv'
    post :payment, on: :member
    get :submit, on: :member
    get :renewal, on: :member
    resources :batches do
      get :health_dec, on: :member
      collection do
        post :import
        get :approve_all
        get :all_health_decs
      end
      # get :approve_selected, on: :collection
      # get :approve_all, on: :collection
      resources :batch_health_decs, as: 'health_declarations'
      resources :batch_dependents, as: 'dependents' do
        collection do
          get :show_all
        end
      end
      resources :batch_beneficiaries, as: 'beneficiaries'
      resources :member_dependents do
        collection do
          post :create_beneficiary
          get :new_beneficiary
        end
      end
    end
  end 
  
  resources :health_decs do
    resources :health_dec_subquestions
  end

  namespace :loan_insurance do
    resources :retentions
    resources :rates
    resources :loans
    resources :details
    resources :batches
    resources :batch_remits
  end


  #* Underwriting Module Routes
  resources :process_claims
  resources :underwriting_routes
  resources :batch_remarks do
    get :form_md, on: :member
  end

  resources :process_remarks do 
    get :view_all, on: :collection
  end
  resources :process_coverages do 
    get :approve_batch, on: :member
    get :deny_batch, on: :member
    get :pending_batch, on: :member
    get :approve
    get :deny
    get :modal_remarks, on: :member
    get :cov_list, on: :collection
    patch :update_batch_selected, on: :collection
  end
  get 'preview', to: 'process_coverages#preview'
  get 'download', to: 'process_coverages#download'
  get 'process_coverages/pdf/:id', to: "process_coverages#pdf", as: 'pc_pdf'


  #* Authentication Routes
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
