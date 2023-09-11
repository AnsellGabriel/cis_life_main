
require 'sidekiq/web'

Rails.application.routes.draw do 
  resources :claim_types, :claim_type_documents, :claim_type_benefits
  resources :documents
  resources :causes
  resources :emp_approvers
  get 'med_directors/home'
  get 'med_director/index'
  
  resources :emp_agreements do 
    get :transfer_index, on: :collection
    get :update_ea_selected, on: :collection
    patch :transfer_agreements, on: :collection
    get :inactive_sub, on: :member
  end
  # resources :denied_dependents
 
  resources :anniversaries, :agent_groups, :departments, :agents, :coop_users, :employees, :plans, :product_benefits, :claim_benefits, :claim_remarks, :claim_coverages

  resources :user do 
    get :approved, on: :member
  end
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
  resources :geo_municipalities do
    get :selected, on: :member
  end
  resources :geo_provinces do
    get :selected, on: :member
  end
  resources :geo_regions do
    get :selected, on: :member
  end
  # resources :agent_groups
  # resources :departments
  # resources :agents
  # resources :coop_users
  # resources :employees
  resources :benefits
  # get 'pages/home'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get "/progress", to: "progress#show"
  get "/progress/update", to: "progress#update"

  #* Coop Module 
  namespace :coop do
    get 'dashboard', to: 'dashboard#index'
  end

  resources :cooperatives do
    get :selected, on: :member
  end
  resources :coop_branches
  
  resources :members do
    collection do
      post :import
    end
  end

  resources :coop_members do
    get :selected, on: :member
    get :member_agreements, on: :member
    get :show_insurance, on: :member
    get :find_member, on: :member
  end

  resources :denied_enrollees, only: [:index, :destroy]

  resources :coop_agreements do
    resources :group_remits
  end

  resources :group_remits do 
    get 'denied_members', to: 'denied_members#index'
    get 'download_csv', to: 'denied_members#download_csv'
    post :payment, on: :member
    get :submit, on: :member
    get :renewal, on: :member
    resources :batches do
      get :health_dec, on: :member
      get :modal_remarks, on: :member
      collection do
        post :import
        get :approve_all
        get :all_health_decs
      end
      # get :approve_selected, on: :collection
      # get :approve_all, on: :collection
      resources :batch_health_decs, as: 'health_declarations' 
      resources :dependent_health_decs, as: 'dep_health_declarations'
      resources :batch_dependents, as: 'dependents' do
        get :health_dec, on: :member
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
    resources :batches do
      get :modal_remarks, on: :member
      collection do
        post :import
      end
    end

    resources :group_remits do
      get :submit, on: :member
    end
  end

  # get 'loan_insurance', to: 'loan_insurance#index'
  get 'insurance/accept', as: 'accept_insurance'
  # get 'insurance/reject', as: 'reject_insurance'
  get 'insurance/terminate', as: 'terminate_insurance'

  #* Underwriting Module Routes
  resources :user_levels
  resources :authority_levels
  resources :process_claims do
    get :new_coop, to: 'process_claims#new_coop', on: :collection
    post :create_coop, to: 'process_claims#create_coop', on: :collection
    get :index_coop, to: 'process_claims#index_coop', on: :collection
    get :index_show, on: :collection
    get :show_coop, on: :member
    get :claim_route, on: :member
    get :claims_file, on: :member
    get :claim_process, on: :member
  end
  resources :underwriting_routes
  resources :batch_remarks do
    get :form_md, on: :member
  end
  resources :dependent_remarks

  resources :process_remarks do 
    get :view_all, on: :collection
  end
  resources :process_coverages do 
    get :approve_batch, on: :member
    get :approve_dependent, on: :member
    get :deny_batch, on: :member
    get :pending_batch, on: :member
    get :reconsider_batch, on: :member
    get :set_premium_batch, on: :member
    post :update_batch_prem, on: :member
    get :approve
    get :deny
    get :reassess
    get :reprocess
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
