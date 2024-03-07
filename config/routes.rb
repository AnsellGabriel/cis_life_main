
require "sidekiq/web"

Rails.application.routes.draw do
  resources :special_arrangements
  resources :sip_pbs
  resources :sip_abs
  resources :koopamilya_pbs
  resources :koopamilya_abs
  resources :reinsurance_members
  resources :reinsurer_ri_batches
  resources :reinsurers
  resources :claim_request_for_payments
  resources :claim_payments
  get "actuarial/index"
  namespace :actuarial do
    resources :reserves
    resources :reserve_batches
  end

  resources :group_proposals
  resources :unit_benefits
  resources :plan_units do
    get :find_units, on: :member
  end
  resources :reinsurances do
    get :reserves_index, on: :collection
  end
  resources :claim_types, :claim_type_documents, :claim_type_benefits, :claim_attachments, :claim_confinements, :claim_benefits, :claim_coverages
  resources :documents
  resources :causes
  resources :emp_approvers
  get "med_directors/home"
  get "med_director/index"

  resources :emp_agreements do
    get :transfer_index, on: :collection
    get :update_ea_selected, on: :collection
    patch :transfer_agreements, on: :collection
    get :inactive_sub, on: :member
  end
  # resources :denied_dependents

  resources :anniversaries, :agent_groups, :departments, :agents, :coop_users, :employees, :product_benefits, :claim_benefits, :claim_coverages

  resources :plans do
    get :selected, on: :member
    get :show_rates, on: :member
    get :show_fields, on: :member
  end


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
  get 'pages/home'
  get 'pages/coso'
  get 'pages/president'
  get 'pages/coop'
  get 'pages/find_graph'
  get "update_charts", to: "pages#update_charts", as: "update_charts"
  get "select_charts", to: "pages#select_charts", as: "select_charts"
  get "update_prem_annum", to: "pages#update_prem_annum", as: "update_prem_annum"
  # get "/pages/modals/modal_charts", to: "pages#modal_charts", as: "modal_charts"
  get "modal_charts", to: "pages#modal_charts", as: "modal_charts"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get "/progress", to: "progress#show"
  get "/progress/update", to: "progress#update"

  # * Coop Module
  namespace :coop do
    get "dashboard", to: "dashboard#index"
  end

  resources :cooperatives do
    get :selected, on: :member
    get :details, on: :member
    get :get_plan, on: :member
  end
  resources :coop_branches

  resources :members do
    collection do
      post :import
    end
    get :show_coverages, on: :member
  end

  resources :coop_members do
    get :selected, on: :member
    get :member_agreements, on: :member
    get :show_insurance, on: :member
    get :find_member, on: :member
  end

  resources :denied_enrollees, only: [:index] do
    # routes for deleting all denied enrolle
    delete :destroy_all, on: :collection
  end

  resources :coop_agreements do
    resources :group_remits do

      resources :remittances, only: [:index]
    end
  end

  resources :group_remits do
    get "denied_members", to: "denied_members#index"
    get "download_csv", to: "denied_members#download_csv"
    delete "destroy_all", to: "denied_members#destroy_all"
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
      resources :batch_health_decs, as: "health_declarations"
      resources :dependent_health_decs, as: "dep_health_declarations"
      resources :batch_dependents, as: "dependents" do
        get :health_dec, on: :member
        collection do
          get :show_all
        end
      end
      resources :batch_beneficiaries, as: "beneficiaries"
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
      get :remove_unused, on: :member
      get :terminate, on: :member
      get :modal_remarks, on: :member
      get :find_loan, on: :member

      collection do
        get :approve_all
      end

      member do
        get :show_unuse_batch, as: "unuse_batch"
      end

      collection do
        post :import
      end

    end

    resources :group_remits do
      get :submit, on: :member
      get :edit_or, on: :member
      get :sii_index, on: :collection
    end

    resources :history, only: [:index]
  end

  # get 'loan_insurance', to: 'loan_insurance#index'
  get "insurance/accept", as: "accept_insurance"
  # get 'insurance/reject', as: 'reject_insurance'
  get "insurance/terminate", as: "terminate_insurance"

  # * Finance Module Routes
  # accounting
  namespace :accounting do
    resources :journals do
      get :download, on: :member
      get :for_approval_index, on: :collection
    end

    resources :checks do
      get :for_approval_index, on: :collection
      get :claimable, on: :member
      # get :cancel, on: :member
      resources :business_checks, as: 'business', except: [:index]
      get :requests, on: :collection
      resources :remarks
      get :download, on: :member
      get :print, on: :member
    end

    resources :check_voucher_requests, only: %i[show]

    get "dashboard", to: "dashboard#index"
  end

  # treasury
  namespace :treasury do
    resources :business_checks, as: 'checks', path: 'checks', only: %w[index edit update] do
      get :requests, on: :collection
      get :search, on: :collection
    end

    resources :payments
    resources :cashier_entries do
      get :print, on: :member
      get :download, on: :member
      get :cancel, on: :member
      get :for_approval_index, on: :collection
      # get :autofill, on: :member
    end

    resources :accounts
    get "dashboard", to: "dashboard#index"
  end

  resources :payments, only: %i[index create show] do
    resources :entries, controller: "payments/entries" do
      get :cancel, on: :member
    end

    resources :remarks, controller: "payments/remarks"
  end

  resources :treasury_cashier_entries, as: 'entries', path: 'entries' , controller: "treasury/cashier_entries" do
    resources :general_ledgers, as: 'ledgers', path: 'ledger' do
      get :post, on: :collection
      get :for_approval, on: :collection
      get :autofill, on: :collection
    end

    resources :billing_statements, as: 'bills', controller: "treasury/billing_statements"
  end

  #* Audit Module Routes
  namespace :audit do
    get 'dashboard', to: 'dashboard#index'
    resources :check_vouchers, only: [:index] do
      get :approve, on: :member
    end
  end

  # * Underwriting Module Routes
  resources :user_levels
  resources :authority_levels
  resources :claim_remarks do
    get :new_status, to: "claim_remarks#new_status", on: :collection
    post :create_status, to: "claim_remarks#create_status", on: :collection
    get :read_message, on: :member
  end

  resources :process_claims do
    get :new_coop, to: "process_claims#new_coop", on: :collection
    post :create_coop, to: "process_claims#create_coop", on: :collection
    get :index_coop, to: "process_claims#index_coop", on: :collection
    get :index_show, on: :collection
    get :show_coop, on: :member
    get :claim_route, on: :member
    get :claims_file, on: :member
    get :claim_process, on: :member
    get :update_status, on: :member
    get :new_ca, to: "process_claims#new_ca", on: :collection
    post :create_ca, to: "process_claims#create_ca", on: :collection
    # get :claimable, on: :collection
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
    get :refund, on: :member
    get :approve_batch, on: :member
    get :approve_dependent, on: :member
    get :deny_batch, on: :member
    get :pending_batch, on: :member
    get :reconsider_batch, on: :member
    get :adjust_lppi_cov, on: :member
    post :update_batch_cov, on: :member
    get :set_premium_batch, on: :member
    post :update_batch_prem, on: :member
    get :approve
    get :deny
    get :reassess
    get :reprocess
    get :modal_remarks, on: :member
    get :psheet, on: :member
    get :cov_list, on: :collection
    patch :update_batch_selected, on: :collection
    get :transfer_to_md, on: :member
  end

  get "preview", to: "process_coverages#preview"
  get "download", to: "process_coverages#download"
  get "process_coverages/pdf/:id", to: "process_coverages#pdf", as: "pc_pdf"

  # * MIS module routes
  namespace :mis do
    get "dashboard", to: "dashboard#index"
    get "cooperatives", to: "cooperatives#index"

    resources :members do
      get :update_table, on: :collection
    end
  end

  # * Authentication Routes
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  devise_for :users, controllers: {
    registrations: "users/registrations"
  }

  devise_scope :user do
    authenticated :user do
      # mount Sidekiq::Web in your Rails app
      root "application#root", as: :authenticated_root
    end

    unauthenticated do
      root "devise/sessions#new", as: :unauthenticated_root
    end
  end

  authenticate :user, -> (u) { u.admin? } do
    mount Sidekiq::Web => "/sidekiq"
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
