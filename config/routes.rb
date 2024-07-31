
require "sidekiq/web"

Rails.application.routes.draw do
  resources :branches
  resources :employee_teams
  resources :teams do
    get :selected, on: :member
  end

  resources :demo_schedules
  resources :transmittals do
    get :remove_or, on: :member
  end

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
  namespace :claims do
    resources :claim_types, :claim_documents, :claim_type_benefits, :claim_confinements, :claim_benefits, :claim_coverages, :claim_distributions, :claim_type_natures, :claim_type_agreements, :claim_retrievals

    resources :cf_accounts do
      get :index_critical, to: "cf_accounts#index_critical", on: :collection
    end

    resources :cf_replenishes do
      get :update_status, to: "cf_replenishes#update_status", on: :member
    end
    resources :cf_availments do
      get :update_status, to: "cf_availments#update_status", on: :member
    end
    resources :claim_coverage_reinsurances do
      get :claim_reinsurance_create, to: "claim_coverage_reinsurances#claim_reinsurance_create", as: "claim_ri_create", on: :collection
      get :claim_reinsurance_update, to: "claim_coverage_reinsurances#claim_reinsurance_update", as: "claim_ri_update", on: :member
    end

    resources :causes do
      post 'create_cause', to: "causes#create"
    end
    resources :claim_attachments do
      get :attach_new_doc, on: :collection
    end

    resources :claim_type_documents do
      get :document_request, to: "claim_type_documents#document_request", on: :member
    end

    resources :process_claims do
      get :new_coop, to: "process_claims#new_coop", on: :collection
      post :create_coop, to: "process_claims#create_coop", on: :collection
      get :index_coop, to: "process_claims#index_coop", on: :collection
      get :index_show, on: :collection
      get :index_claim_type, on: :collection
      get :show_coop, on: :member
      get :claim_route, on: :member
      get :claims_file, on: :member
      get :claim_process, on: :member
      get :update_status, on: :member
      get :new_ca, to: "process_claims#new_ca", on: :collection
      get :edit_ca, to: "process_claims#edit_ca", on: :member
      get :edit_coop, to: "process_claims#edit_coop", on: :member
      post :create_ca, to: "process_claims#create_ca", on: :collection
      patch :update_ca, to: "process_claims#update_ca", on: :member
      patch :update_coop, to: "process_claims#update_coop", on: :member
      get :print_sheet, to: "process_claims#print_sheet", on: :member
      get :claims_dashboard, to: "process_claims#claims_dashboard", on: :collection
      get :approve_claim_debit, on: :member
      # get :claimable, on: :collection
      resources :remarks
    end

    resources :claim_remarks do
      get :new_status, to: "claim_remarks#new_status", on: :collection
      post :create_status, to: "claim_remarks#create_status", on: :collection
      get :message_history, to: "claim_remarks#message_history", on: :collection
      get :read_message, on: :member
      get :unread_messages, on: :collection
    end
  end




  resources :documents
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

  resources :anniversaries, :agent_groups, :departments, :agents, :coop_users, :employees, :product_benefits

  resources :plans do
    get :selected, on: :member
    get :show_rates, on: :member
    get :show_fields, on: :member
  end

  resources :dashboards do
    get :actuarial, on: :collection
    get :claims, on: :collection
    get :mis, on: :collection
    get :coop, on: :collection
    get :treasury, on: :collection
    get :accounting, on: :collection
    get :coso, on: :collection
    get :admin, on: :collection
  end
  
  resources :analytics do 
    get :claims, on: :collection
  end

  resources :user do
    get :approved, on: :member
    get :admin_dashboard, on: :collection
  end

  resources :agreement_benefits do
    get :selected, on: :member
  end

  resources :agreements do
    get :show_details, on: :member
    post :update_ors, on: :member
    get :selected, on: :member
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
    get :select_agreement, on: :member
    get :details, on: :member
    get :get_plan, on: :member
    resources :coop_banks
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
    resources :remarks, controller: "group_remit/remarks"
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
      get :adjusted, on: :member
      post :accept_adjustment, on: :member
      post :cancel_coverage, on: :member
      get :adjustments, on: :member
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
      get "lppi_summary", on: :member
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
    resources :account_beginning_balances
    resources :debit_advices do
      get :new_receipt, on: :member
      post :upload_receipt, on: :member
      get :download, on: :member
    end

    resources :journals do
      get :download, on: :member
      get :for_approval_index, on: :collection
      # get :for_jv, on: :collection
      get :requests, on: :collection
    end

    resources :checks do
      # get :for_approval_index, on: :collection
      get :claimable, on: :member
      # get :cancel, on: :member
      resources :business_checks, as: 'business', except: [:index]
      get :requests, on: :collection
      resources :remarks
      get :download, on: :member
      get :print, on: :member
    end

    resources :general_disbursement_book, only: %i[index] do
      get :pdf, on: :collection
    end

    resources :journal_book, only: %i[index] do
      get :pdf, on: :collection
    end

    resources :receipt_book, only: %i[index] do
      get :pdf, on: :collection
    end

    resources :voucher_requests, only: %i[index show]

    get "dashboard", to: "dashboard#index"
    get "for_approval", to: "dashboard#for_approval"
  end

  resources :payees

  # treasury
  namespace :treasury do
    resources :sub_accounts
    resources :payment_types
    resources :business_checks, as: 'checks', path: 'checks', only: %w[index edit update] do
      get :requests, on: :collection
      get :search, on: :collection
    end

    # resources :payments
    resources :cashier_entries do
      get :print, on: :member
      get :download, on: :member
      get :cancel, on: :member
      get :for_approval_index, on: :collection
      # get :autofill, on: :member
    end

    resources :accounts do
      get :show_report, on: :collection
      get :show_pdf, on: :collection
    end

    get "dashboard", to: "dashboard#index"
    get "for_approval", to: "dashboard#for_approval"

    resources :debit_advices, only: %i[index]
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

    resources :for_audits do
      get :approve, on: :member
    end
  end

  # * Underwriting Module Routes
  resources :user_levels
  resources :authority_levels



  resources :underwriting_routes
  resources :batch_remarks do
    get :form_md, on: :member
    post :accept_adjustment, on: :member
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
    get :refund_form, on: :member
    post :update_batch_prem, on: :member
    get :approve
    get :deny
    get :reassess
    get :reprocess
    get :modal_remarks, on: :member
    get :psheet, on: :member
    get :cov_list, on: :collection
    get :substandard_batches, on: :collection
    patch :update_batch_selected, on: :collection
    get :transfer_to_md, on: :member
    get :und, on: :collection
    get :gen_csv, on: :collection
    post :set_processor, on: :member
  end

  get "product_csv", to: "process_coverages#product_csv"
  get "ri_csv", to: "reinsurances#ri_csv"
  get "download", to: "process_coverages#download"
  get "process_coverages/pdf/:id", to: "process_coverages#pdf", as: "pc_pdf"

  # * MIS module routes
  namespace :mis do
    get "dashboard", to: "dashboard#index"
    get "cooperatives", to: "cooperatives#index"
    get "view_ors", to: "dashboard#view_ors"

    resources :members, only: [:index, :show]
  end

  # * Authentication Routes
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  devise_for :users, controllers: {
    registrations: "users/registrations"
  }

  devise_scope :user do
    authenticated :user do
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

  #* Reports Module Routes
  namespace :reports do
    resources :accounts, only: [:index, :show] do
      get :trial_balance, on: :collection
    end
  end
end
