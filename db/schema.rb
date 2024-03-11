# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2024_03_11_010451) do
  create_table "accounting_vouchers", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.date "date_voucher"
    t.integer "voucher"
    t.string "payable_type", null: false
    t.bigint "payable_id", null: false
    t.bigint "treasury_account_id"
    t.decimal "amount", precision: 15, scale: 2
    t.text "particulars"
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0
    t.bigint "check_voucher_request_id"
    t.boolean "claimable", default: false
    t.integer "audit", default: 0
    t.integer "audited_by"
    t.date "post_date"
    t.integer "accountant_id"
    t.integer "approved_by"
    t.integer "certified_by"
    t.index ["check_voucher_request_id"], name: "index_accounting_vouchers_on_check_voucher_request_id"
    t.index ["payable_type", "payable_id"], name: "index_accounting_vouchers_on_payable"
    t.index ["treasury_account_id"], name: "index_accounting_vouchers_on_treasury_account_id"
  end

  create_table "action_text_rich_texts", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.text "body", size: :long
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_admin_comments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

  create_table "active_storage_attachments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "actuarial_reserve_batches", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "actuarial_reserve_id"
    t.string "batchable_type"
    t.bigint "batchable_id"
    t.integer "term"
    t.decimal "rate", precision: 5, scale: 2
    t.decimal "coverage_less_ri", precision: 10, scale: 2
    t.decimal "prem_less_ri", precision: 10, scale: 2
    t.integer "duration"
    t.integer "first_term"
    t.integer "second_term"
    t.integer "third_term"
    t.decimal "unearned_prem", precision: 10, scale: 2
    t.decimal "first_adv_prem", precision: 10, scale: 2
    t.decimal "second_adv_prem", precision: 10, scale: 2
    t.decimal "reserve_amt", precision: 10, scale: 2
    t.decimal "cov_less_ret", precision: 10, scale: 2
    t.decimal "prem_less_ret", precision: 10, scale: 2
    t.decimal "unearned_pr", precision: 10, scale: 2
    t.decimal "first_adv_pr", precision: 10, scale: 2
    t.decimal "second_adv_pr", precision: 10, scale: 2
    t.decimal "reserve_ret_amt", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["actuarial_reserve_id"], name: "index_actuarial_reserve_batches_on_actuarial_reserve_id"
    t.index ["batchable_type", "batchable_id"], name: "index_actuarial_reserve_batches_on_batchable"
  end

  create_table "actuarial_reserves", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.date "first_term"
    t.date "second_term"
    t.date "third_term"
    t.decimal "total_unearned_prem", precision: 10, scale: 2
    t.decimal "total_first_advance_prem", precision: 10, scale: 2
    t.decimal "total_second_advance_prem", precision: 10, scale: 2
    t.decimal "total_reserve", precision: 10, scale: 2
    t.decimal "total_unearned_pr", precision: 10, scale: 2
    t.decimal "total_first_advance_pr", precision: 10, scale: 2
    t.decimal "total_second_advance_pr", precision: 10, scale: 2
    t.decimal "total_reserve_ret", precision: 10, scale: 2
    t.bigint "plan_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plan_id"], name: "index_actuarial_reserves_on_plan_id"
  end

  create_table "admin_users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "agent_groups", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "agents", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "last_name"
    t.string "first_name"
    t.string "middle_name"
    t.date "birthdate"
    t.string "mobile_number"
    t.bigint "agent_group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["agent_group_id"], name: "index_agents_on_agent_group_id"
  end

  create_table "agreement_benefits", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "agreement_id"
    t.string "name"
    t.text "description"
    t.decimal "min_age", precision: 10, scale: 3
    t.decimal "max_age", precision: 10, scale: 3
    t.integer "insured_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "exit_age", precision: 10, scale: 3
    t.boolean "with_dependent", default: false
    t.integer "batches_count"
    t.index ["agreement_id"], name: "index_agreement_benefits_on_agreement_id"
  end

  create_table "agreement_proposals", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "agreement_id"
    t.bigint "group_proposal_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["agreement_id"], name: "index_agreement_proposals_on_agreement_id"
    t.index ["group_proposal_id"], name: "index_agreement_proposals_on_group_proposal_id"
  end

  create_table "agreements", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "plan_id"
    t.bigint "cooperative_id"
    t.bigint "agent_id"
    t.string "moa_no"
    t.integer "contestability"
    t.decimal "nel", precision: 12, scale: 2, default: "25000.0"
    t.decimal "nml", precision: 12, scale: 2
    t.string "anniversary_type"
    t.boolean "transferred"
    t.date "transferred_date"
    t.string "previous_provider"
    t.string "comm_type"
    t.boolean "claims_fund"
    t.decimal "entry_age_from", precision: 5, scale: 2
    t.decimal "entry_age_to", precision: 5, scale: 2
    t.decimal "exit_age", precision: 5, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description"
    t.decimal "coop_sf", precision: 10, scale: 2
    t.decimal "agent_sf", precision: 10, scale: 2
    t.integer "minimum_participation"
    t.decimal "claims_fund_amount", precision: 10, scale: 2
    t.boolean "reconsiderable", default: false
    t.boolean "unusable", default: false
    t.integer "minimum_term", default: 0
    t.decimal "minimum_premium", precision: 10, scale: 2, default: "0.0"
    t.boolean "with_markup", default: false
    t.index ["agent_id"], name: "index_agreements_on_agent_id"
    t.index ["cooperative_id"], name: "index_agreements_on_cooperative_id"
    t.index ["plan_id"], name: "index_agreements_on_plan_id"
  end

  create_table "agreements_coop_members", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "coop_member_id", null: false
    t.bigint "agreement_id", null: false
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "expiry"
    t.date "effectivity"
    t.index ["agreement_id"], name: "index_agreements_coop_members_on_agreement_id"
    t.index ["coop_member_id"], name: "index_agreements_coop_members_on_coop_member_id"
  end

  create_table "anniversaries", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.date "anniversary_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "agreement_id", null: false
    t.index ["agreement_id"], name: "index_anniversaries_on_agreement_id"
  end

  create_table "authority_levels", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.decimal "maxAmount", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "batch_beneficiaries", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "batch_id", null: false
    t.bigint "member_dependent_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["batch_id"], name: "index_batch_beneficiaries_on_batch_id"
    t.index ["member_dependent_id"], name: "index_batch_beneficiaries_on_member_dependent_id"
  end

  create_table "batch_dependents", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "batch_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "member_dependent_id", null: false
    t.decimal "premium", precision: 10, scale: 2
    t.decimal "coop_sf_amount", precision: 10, scale: 2
    t.decimal "agent_sf_amount", precision: 10, scale: 2
    t.bigint "agreement_benefit_id", null: false
    t.boolean "valid_health_dec", default: false
    t.integer "insurance_status", default: 3
    t.index ["agreement_benefit_id"], name: "index_batch_dependents_on_agreement_benefit_id"
    t.index ["batch_id"], name: "index_batch_dependents_on_batch_id"
    t.index ["member_dependent_id"], name: "index_batch_dependents_on_member_dependent_id"
  end

  create_table "batch_group_remits", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "batch_id", null: false
    t.bigint "group_remit_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["batch_id"], name: "index_batch_group_remits_on_batch_id"
    t.index ["group_remit_id"], name: "index_batch_group_remits_on_group_remit_id"
  end

  create_table "batch_health_decs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "answer"
    t.string "answerable_type", null: false
    t.bigint "answerable_id", null: false
    t.string "healthdecable_type", null: false
    t.bigint "healthdecable_id", null: false
    t.index ["answerable_type", "answerable_id"], name: "index_batch_health_decs_on_answerable"
    t.index ["healthdecable_type", "healthdecable_id"], name: "index_batch_health_decs_on_healthdecable"
  end

  create_table "batch_remarks", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.text "remark"
    t.integer "status"
    t.string "user_type", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "remarkable_type", null: false
    t.bigint "remarkable_id", null: false
    t.index ["remarkable_type", "remarkable_id"], name: "index_batch_remarks_on_remarkable"
    t.index ["user_type", "user_id"], name: "index_batch_remarks_on_user"
  end

  create_table "batches", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.date "effectivity_date"
    t.date "expiry_date"
    t.boolean "active"
    t.decimal "coop_sf_amount", precision: 10, scale: 2
    t.decimal "agent_sf_amount", precision: 10, scale: 2
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "premium", precision: 10, scale: 2
    t.integer "age"
    t.integer "insurance_status", default: 3
    t.bigint "coop_member_id", null: false
    t.boolean "transferred"
    t.bigint "agreement_benefit_id", null: false
    t.boolean "valid_health_dec", default: false
    t.boolean "below_nel", default: false
    t.integer "duration"
    t.integer "residency"
    t.date "previous_effectivity_date"
    t.date "previous_expiry_date"
    t.boolean "for_md", default: false
    t.string "first_name"
    t.string "middle_name"
    t.string "last_name"
    t.string "civil_status"
    t.date "birthdate"
    t.index ["agreement_benefit_id"], name: "index_batches_on_agreement_benefit_id"
    t.index ["coop_member_id"], name: "index_batches_on_coop_member_id"
  end

  create_table "benefits", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "acronym"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "benefit_type"
  end

  create_table "causes", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "check_voucher_requests", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "requestable_type", null: false
    t.bigint "requestable_id", null: false
    t.decimal "amount", precision: 10, scale: 2
    t.integer "status"
    t.string "analyst"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "payment_type"
    t.index ["requestable_type", "requestable_id"], name: "index_check_voucher_requests_on_requestable"
  end

  create_table "claim_attachments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "process_claim_id", null: false
    t.bigint "claim_type_document_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["claim_type_document_id"], name: "index_claim_attachments_on_claim_type_document_id"
    t.index ["process_claim_id"], name: "index_claim_attachments_on_process_claim_id"
  end

  create_table "claim_benefits", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "process_claim_id"
    t.bigint "benefit_id"
    t.decimal "amount", precision: 12, scale: 2
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["benefit_id"], name: "index_claim_benefits_on_benefit_id"
    t.index ["process_claim_id"], name: "index_claim_benefits_on_process_claim_id"
  end

  create_table "claim_causes", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.text "acd"
    t.text "ucd"
    t.text "osccd"
    t.text "icd"
    t.bigint "process_claim_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["process_claim_id"], name: "index_claim_causes_on_process_claim_id"
  end

  create_table "claim_confinements", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "process_claim_id"
    t.date "date_admit"
    t.date "date_discharge"
    t.decimal "terms", precision: 6, scale: 2
    t.decimal "amount", precision: 12, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["process_claim_id"], name: "index_claim_confinements_on_process_claim_id"
  end

  create_table "claim_coverages", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "process_claim_id"
    t.string "coverageable_type", null: false
    t.bigint "coverageable_id", null: false
    t.decimal "amount_benefit", precision: 12, scale: 2
    t.string "coverage_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["coverageable_type", "coverageable_id"], name: "index_claim_coverages_on_coverageable"
    t.index ["process_claim_id"], name: "index_claim_coverages_on_process_claim_id"
  end

  create_table "claim_payments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "beneficiary"
    t.decimal "amount", precision: 15, scale: 2
    t.bigint "process_claim_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["process_claim_id"], name: "index_claim_payments_on_process_claim_id"
  end

  create_table "claim_remarks", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "process_claim_id", null: false
    t.bigint "user_id", null: false
    t.integer "status"
    t.text "remark"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "coop"
    t.boolean "read"
    t.boolean "pin"
    t.index ["process_claim_id"], name: "index_claim_remarks_on_process_claim_id"
    t.index ["user_id"], name: "index_claim_remarks_on_user_id"
  end

  create_table "claim_request_for_payments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "process_claim_id", null: false
    t.decimal "amount", precision: 15, scale: 2
    t.integer "status", default: 0
    t.string "analyst"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description"
    t.index ["process_claim_id"], name: "index_claim_request_for_payments_on_process_claim_id"
  end

  create_table "claim_type_benefits", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "claim_type_id"
    t.bigint "benefit_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["benefit_id"], name: "index_claim_type_benefits_on_benefit_id"
    t.index ["claim_type_id"], name: "index_claim_type_benefits_on_claim_type_id"
  end

  create_table "claim_type_documents", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "claim_type_id"
    t.bigint "document_id"
    t.boolean "required"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["claim_type_id"], name: "index_claim_type_documents_on_claim_type_id"
    t.index ["document_id"], name: "index_claim_type_documents_on_document_id"
  end

  create_table "claim_types", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "coop_branches", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "contact_details"
    t.bigint "cooperative_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.string "street"
    t.string "email"
    t.string "branch_head"
    t.bigint "geo_region_id"
    t.bigint "geo_province_id"
    t.bigint "geo_municipality_id"
    t.bigint "geo_barangay_id"
    t.index ["cooperative_id"], name: "index_coop_branches_on_cooperative_id"
    t.index ["geo_barangay_id"], name: "index_coop_branches_on_geo_barangay_id"
    t.index ["geo_municipality_id"], name: "index_coop_branches_on_geo_municipality_id"
    t.index ["geo_province_id"], name: "index_coop_branches_on_geo_province_id"
    t.index ["geo_region_id"], name: "index_coop_branches_on_geo_region_id"
  end

  create_table "coop_members", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "cooperative_id", null: false
    t.bigint "coop_branch_id", null: false
    t.bigint "member_id", null: false
    t.date "membership_date"
    t.boolean "transferred", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "full_name"
    t.boolean "deceased", default: false
    t.index ["coop_branch_id"], name: "index_coop_members_on_coop_branch_id"
    t.index ["cooperative_id"], name: "index_coop_members_on_cooperative_id"
    t.index ["member_id"], name: "index_coop_members_on_member_id"
  end

  create_table "coop_types", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "coop_users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "last_name"
    t.string "first_name"
    t.string "middle_name"
    t.date "birthdate"
    t.string "mobile_number"
    t.string "designation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "cooperative_id", null: false
    t.bigint "coop_branch_id", null: false
    t.index ["coop_branch_id"], name: "index_coop_users_on_coop_branch_id"
    t.index ["cooperative_id"], name: "index_coop_users_on_cooperative_id"
  end

  create_table "cooperatives", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.string "registration_number"
    t.string "cooperative_type"
    t.string "acronym"
    t.string "street"
    t.string "email"
    t.string "contact_number"
    t.bigint "geo_region_id"
    t.bigint "geo_province_id"
    t.bigint "geo_municipality_id"
    t.bigint "geo_barangay_id"
    t.bigint "coop_type_id"
    t.index ["coop_type_id"], name: "index_cooperatives_on_coop_type_id"
    t.index ["geo_barangay_id"], name: "index_cooperatives_on_geo_barangay_id"
    t.index ["geo_municipality_id"], name: "index_cooperatives_on_geo_municipality_id"
    t.index ["geo_province_id"], name: "index_cooperatives_on_geo_province_id"
    t.index ["geo_region_id"], name: "index_cooperatives_on_geo_region_id"
  end

  create_table "denied_dependents", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "age"
    t.string "reason"
    t.boolean "beneficiary"
    t.boolean "dependent"
    t.bigint "group_remit_id", null: false
    t.bigint "batch_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["batch_id"], name: "index_denied_dependents_on_batch_id"
    t.index ["group_remit_id"], name: "index_denied_dependents_on_group_remit_id"
  end

  create_table "denied_enrollees", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "reason"
    t.bigint "cooperative_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cooperative_id"], name: "index_denied_enrollees_on_cooperative_id"
  end

  create_table "denied_members", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.integer "age"
    t.string "reason"
    t.bigint "group_remit_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_remit_id"], name: "index_denied_members_on_group_remit_id"
  end

  create_table "departments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "dependent_health_decs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "batch_dependent_id", null: false
    t.text "answer"
    t.string "answerable_type", null: false
    t.bigint "answerable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["answerable_type", "answerable_id"], name: "index_dependent_health_decs_on_answerable"
    t.index ["batch_dependent_id"], name: "index_dependent_health_decs_on_batch_dependent_id"
  end

  create_table "dependent_remarks", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "batch_dependent_id", null: false
    t.text "remark"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "userable_type", null: false
    t.bigint "userable_id", null: false
    t.index ["batch_dependent_id"], name: "index_dependent_remarks_on_batch_dependent_id"
    t.index ["userable_type", "userable_id"], name: "index_dependent_remarks_on_userable"
  end

  create_table "documents", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "emp_agreements", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "employee_id"
    t.bigint "agreement_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: true
    t.integer "category_type"
    t.index ["agreement_id"], name: "index_emp_agreements_on_agreement_id"
    t.index ["employee_id"], name: "index_emp_agreements_on_employee_id"
  end

  create_table "emp_approvers", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "employee_id"
    t.bigint "approver_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["approver_id"], name: "index_emp_approvers_on_approver_id"
    t.index ["employee_id"], name: "index_emp_approvers_on_employee_id"
  end

  create_table "employees", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "last_name"
    t.string "first_name"
    t.string "middle_name"
    t.date "birthdate"
    t.string "employee_number"
    t.string "mobile_number"
    t.string "designation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "department_id", null: false
    t.integer "branch"
    t.index ["department_id"], name: "index_employees_on_department_id"
  end

  create_table "general_ledgers", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "ledgerable_type", null: false
    t.bigint "ledgerable_id", null: false
    t.bigint "account_id", null: false
    t.text "description"
    t.integer "ledger_type"
    t.decimal "amount", precision: 15, scale: 2, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "transaction_date"
    t.index ["account_id"], name: "index_general_ledgers_on_account_id"
    t.index ["ledgerable_type", "ledgerable_id"], name: "index_general_ledgers_on_ledgerable"
  end

  create_table "geo_barangays", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.bigint "geo_region_id"
    t.bigint "geo_province_id"
    t.bigint "geo_municipality_id"
    t.string "psgc_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["geo_municipality_id"], name: "index_geo_barangays_on_geo_municipality_id"
    t.index ["geo_province_id"], name: "index_geo_barangays_on_geo_province_id"
    t.index ["geo_region_id"], name: "index_geo_barangays_on_geo_region_id"
  end

  create_table "geo_municipalities", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.bigint "geo_region_id"
    t.bigint "geo_province_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["geo_province_id"], name: "index_geo_municipalities_on_geo_province_id"
    t.index ["geo_region_id"], name: "index_geo_municipalities_on_geo_region_id"
  end

  create_table "geo_provinces", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.bigint "geo_region_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["geo_region_id"], name: "index_geo_provinces_on_geo_region_id"
  end

  create_table "geo_regions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "group_proposals", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "cooperative_id"
    t.bigint "plan_id"
    t.bigint "plan_unit_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "agent_id"
    t.string "anniversary_type"
    t.index ["agent_id"], name: "index_group_proposals_on_agent_id"
    t.index ["cooperative_id"], name: "index_group_proposals_on_cooperative_id"
    t.index ["plan_id"], name: "index_group_proposals_on_plan_id"
    t.index ["plan_unit_id"], name: "index_group_proposals_on_plan_unit_id"
  end

  create_table "group_remits", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.bigint "agreement_id", null: false
    t.integer "anniversary_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "effectivity_date"
    t.date "expiry_date"
    t.integer "terms"
    t.integer "status", default: 0
    t.decimal "gross_premium", precision: 10, scale: 2
    t.decimal "net_premium", precision: 10, scale: 2
    t.decimal "coop_commission", precision: 10, scale: 2
    t.decimal "agent_commission", precision: 10, scale: 2
    t.string "type"
    t.integer "batch_remit_id"
    t.date "date_submitted"
    t.integer "official_receipt"
    t.boolean "mis_entry", default: false
    t.decimal "refund_amount", precision: 15, scale: 2
    t.boolean "refunded", default: false
    t.integer "refund_status", default: 0
    t.index ["agreement_id"], name: "index_group_remits_on_agreement_id"
    t.index ["anniversary_id"], name: "index_group_remits_on_anniversary_id"
  end

  create_table "health_dec_subquestions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "health_dec_id", null: false
    t.text "question"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["health_dec_id"], name: "index_health_dec_subquestions_on_health_dec_id"
  end

  create_table "health_decs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.text "question"
    t.boolean "active"
    t.boolean "with_details"
    t.boolean "valid_answer"
    t.integer "question_sort"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "koopamilya_abs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.integer "min_age"
    t.integer "max_age"
    t.integer "insured_type"
    t.integer "exit_age"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "groupings"
  end

  create_table "koopamilya_pbs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "koopamilya_ab_id"
    t.decimal "coverage_amount", precision: 15, scale: 2
    t.bigint "benefit_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["benefit_id"], name: "index_koopamilya_pbs_on_benefit_id"
    t.index ["koopamilya_ab_id"], name: "index_koopamilya_pbs_on_koopamilya_ab_id"
  end

  create_table "loan_insurance_batches", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "coop_member_id", null: false
    t.bigint "group_remit_id", null: false
    t.integer "age"
    t.date "effectivity_date"
    t.date "expiry_date"
    t.date "date_release"
    t.date "date_mature"
    t.integer "terms"
    t.decimal "unused", precision: 10, scale: 2
    t.decimal "premium", precision: 10, scale: 2
    t.decimal "premium_due", precision: 10, scale: 2
    t.decimal "coop_sf_amount", precision: 10, scale: 2
    t.decimal "agent_sf_amount", precision: 10, scale: 2
    t.boolean "valid_health_dec", default: false
    t.decimal "loan_amount", precision: 10, scale: 2
    t.bigint "loan_insurance_rate_id", null: false
    t.boolean "reinsurance"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "loan_insurance_loan_id"
    t.integer "insurance_status"
    t.integer "status"
    t.boolean "terminated"
    t.date "terminate_date"
    t.integer "unused_loan_id"
    t.decimal "excess", precision: 10, scale: 2, default: "0.0"
    t.boolean "substandard", default: false
    t.boolean "for_md", default: false
    t.string "first_name"
    t.string "middle_name"
    t.string "last_name"
    t.date "birthdate"
    t.string "civil_status"
    t.index ["coop_member_id"], name: "index_loan_insurance_batches_on_coop_member_id"
    t.index ["group_remit_id"], name: "index_loan_insurance_batches_on_group_remit_id"
    t.index ["loan_insurance_loan_id"], name: "index_loan_insurance_batches_on_loan_insurance_loan_id"
    t.index ["loan_insurance_rate_id"], name: "index_loan_insurance_batches_on_loan_insurance_rate_id"
  end

  create_table "loan_insurance_details", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "batch_id", null: false
    t.decimal "unused", precision: 10, scale: 2
    t.decimal "loan_amount", precision: 10, scale: 2
    t.decimal "premium_due", precision: 10, scale: 2
    t.decimal "substandard_rate", precision: 10, scale: 2
    t.boolean "terminated"
    t.date "terminate_date"
    t.boolean "reinsurance"
    t.integer "terms"
    t.date "date_release"
    t.date "date_mature"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "loan_insurance_loan_id", null: false
    t.bigint "loan_insurance_rate_id", null: false
    t.bigint "loan_insurance_retention_id", null: false
    t.index ["batch_id"], name: "index_loan_insurance_details_on_batch_id"
    t.index ["loan_insurance_loan_id"], name: "index_loan_insurance_details_on_loan_insurance_loan_id"
    t.index ["loan_insurance_rate_id"], name: "index_loan_insurance_details_on_loan_insurance_rate_id"
    t.index ["loan_insurance_retention_id"], name: "index_loan_insurance_details_on_loan_insurance_retention_id"
  end

  create_table "loan_insurance_loans", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.bigint "cooperative_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "for_sii", default: false
    t.index ["cooperative_id"], name: "index_loan_insurance_loans_on_cooperative_id"
  end

  create_table "loan_insurance_rates", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "min_age"
    t.integer "max_age"
    t.decimal "monthly_rate", precision: 5, scale: 2
    t.decimal "annual_rate", precision: 5, scale: 2
    t.decimal "daily_rate", precision: 5, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "agreement_id", null: false
    t.decimal "min_amount", precision: 15, scale: 2
    t.decimal "max_amount", precision: 15, scale: 2
    t.decimal "nel", precision: 10, scale: 2
    t.decimal "nml", precision: 10, scale: 2
    t.integer "contestability"
    t.decimal "markup_rate", precision: 10, scale: 6
    t.decimal "markup_sf", precision: 10, scale: 4
    t.index ["agreement_id"], name: "index_loan_insurance_rates_on_agreement_id"
  end

  create_table "loan_insurance_retentions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.decimal "amount", precision: 15, scale: 2
    t.boolean "active"
    t.date "date_activated"
    t.date "date_deactivated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "member_dependents", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "last_name"
    t.string "first_name"
    t.string "middle_name"
    t.string "suffix"
    t.date "birth_date"
    t.string "relationship"
    t.bigint "member_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["member_id"], name: "index_member_dependents_on_member_id"
  end

  create_table "members", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "last_name"
    t.string "first_name"
    t.string "middle_name"
    t.string "suffix"
    t.string "email"
    t.string "mobile_number"
    t.date "birth_date"
    t.string "birth_place"
    t.string "gender"
    t.string "sss_no"
    t.string "tin_no"
    t.string "address"
    t.string "civil_status"
    t.string "legal_spouse"
    t.float "height"
    t.float "weight"
    t.string "occupation"
    t.string "employer"
    t.string "work_address"
    t.string "work_phone_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "street"
    t.bigint "geo_region_id"
    t.bigint "geo_province_id"
    t.bigint "geo_municipality_id"
    t.bigint "geo_barangay_id"
    t.decimal "total_loan_amount", precision: 15, scale: 2, default: "0.0"
    t.boolean "for_reinsurance", default: false
    t.index ["geo_barangay_id"], name: "index_members_on_geo_barangay_id"
    t.index ["geo_municipality_id"], name: "index_members_on_geo_municipality_id"
    t.index ["geo_province_id"], name: "index_members_on_geo_province_id"
    t.index ["geo_region_id"], name: "index_members_on_geo_region_id"
  end

  create_table "notifications", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.text "message"
    t.string "notifiable_type", null: false
    t.bigint "notifiable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "viewed", default: false
    t.index ["notifiable_type", "notifiable_id"], name: "index_notifications_on_notifiable"
  end

  create_table "payees", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.text "description"
    t.string "contact_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "receipt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "payable_type", null: false
    t.bigint "payable_id", null: false
    t.integer "status", default: 0
    t.decimal "amount", precision: 15, scale: 2
    t.index ["payable_type", "payable_id"], name: "index_payments_on_payable"
  end

  create_table "plan_units", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "plan_id"
    t.string "name"
    t.decimal "total_prem", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plan_id"], name: "index_plan_units_on_plan_id"
  end

  create_table "plans", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "acronym"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "dependable", default: false
  end

  create_table "process_claims", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "cooperative_id", null: false
    t.bigint "agreement_id", null: false
    t.date "date_incident"
    t.integer "entry_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "claimant_email"
    t.string "claimant_contact_no"
    t.integer "nature_of_claim"
    t.bigint "agreement_benefit_id", null: false
    t.string "claimant_name"
    t.string "relationship"
    t.integer "claim_route"
    t.string "claimable_type", null: false
    t.bigint "claimable_id", null: false
    t.integer "age"
    t.bigint "cause_id"
    t.date "date_file"
    t.boolean "claim_filed"
    t.boolean "processing"
    t.boolean "approval"
    t.boolean "payment"
    t.bigint "claim_type_id"
    t.integer "status"
    t.index ["agreement_benefit_id"], name: "index_process_claims_on_agreement_benefit_id"
    t.index ["agreement_id"], name: "index_process_claims_on_agreement_id"
    t.index ["cause_id"], name: "index_process_claims_on_cause_id"
    t.index ["claim_type_id"], name: "index_process_claims_on_claim_type_id"
    t.index ["claimable_type", "claimable_id"], name: "index_process_claims_on_claimable"
    t.index ["cooperative_id"], name: "index_process_claims_on_cooperative_id"
  end

  create_table "process_coverages", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "group_remit_id"
    t.bigint "agent_id"
    t.date "effectivity"
    t.date "expiry"
    t.integer "status"
    t.integer "approved_count"
    t.decimal "approved_total_coverage", precision: 20, scale: 4
    t.decimal "approved_total_prem", precision: 20, scale: 4
    t.integer "denied_count"
    t.decimal "denied_total_coverage", precision: 20, scale: 4
    t.decimal "denied_total_prem", precision: 20, scale: 4
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "und_route"
    t.bigint "processor_id"
    t.bigint "approver_id"
    t.boolean "reprocess"
    t.date "process_date"
    t.date "evaluate_date"
    t.bigint "who_processed_id"
    t.bigint "who_approved_id"
    t.index ["agent_id"], name: "index_process_coverages_on_agent_id"
    t.index ["approver_id"], name: "index_process_coverages_on_approver_id"
    t.index ["group_remit_id"], name: "index_process_coverages_on_group_remit_id"
    t.index ["processor_id"], name: "index_process_coverages_on_processor_id"
    t.index ["und_route"], name: "index_process_coverages_on_und_route"
    t.index ["who_approved_id"], name: "index_process_coverages_on_who_approved_id"
    t.index ["who_processed_id"], name: "index_process_coverages_on_who_processed_id"
  end

  create_table "process_remarks", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "process_coverage_id"
    t.text "remark"
    t.integer "status"
    t.string "user_type"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["process_coverage_id"], name: "index_process_remarks_on_process_coverage_id"
    t.index ["user_type", "user_id"], name: "index_process_remarks_on_user"
  end

  create_table "process_tracks", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "description"
    t.integer "route_id"
    t.bigint "user_id", null: false
    t.string "trackable_type", null: false
    t.bigint "trackable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["trackable_type", "trackable_id"], name: "index_process_tracks_on_trackable"
    t.index ["user_id"], name: "index_process_tracks_on_user_id"
  end

  create_table "product_benefits", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.decimal "coverage_amount", precision: 10, scale: 2
    t.decimal "premium", precision: 10, scale: 2
    t.bigint "agreement_benefit_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "benefit_id", null: false
    t.integer "duration"
    t.integer "residency_floor"
    t.integer "residency_ceiling"
    t.string "benefit_type"
    t.boolean "main"
    t.index ["agreement_benefit_id"], name: "index_product_benefits_on_agreement_benefit_id"
    t.index ["benefit_id"], name: "index_product_benefits_on_benefit_id"
  end

  create_table "progress_trackers", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.float "progress", default: 0.0
    t.string "trackable_type", null: false
    t.bigint "trackable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["trackable_type", "trackable_id"], name: "index_progress_trackers_on_trackable"
  end

  create_table "reinsurance_batches", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "batch_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "ri_date"
    t.date "ri_effectivity"
    t.date "ri_expiry"
    t.integer "ri_terms"
    t.bigint "reinsurance_member_id"
    t.index ["batch_id"], name: "index_reinsurance_batches_on_batch_id"
    t.index ["reinsurance_member_id"], name: "index_reinsurance_batches_on_reinsurance_member_id"
  end

  create_table "reinsurance_members", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "reinsurance_id"
    t.bigint "member_id"
    t.decimal "total_loan_amount", precision: 20, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["member_id"], name: "index_reinsurance_members_on_member_id"
    t.index ["reinsurance_id"], name: "index_reinsurance_members_on_reinsurance_id"
  end

  create_table "reinsurances", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.date "date_from"
    t.date "date_to"
    t.decimal "ri_total_amount", precision: 10
    t.decimal "ri_total_prem", precision: 10
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reinsurer_ri_batches", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "reinsurance_batch_id"
    t.bigint "reinsurer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reinsurance_batch_id"], name: "index_reinsurer_ri_batches_on_reinsurance_batch_id"
    t.index ["reinsurer_id"], name: "index_reinsurer_ri_batches_on_reinsurer_id"
  end

  create_table "reinsurers", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "short_name"
    t.string "address"
    t.string "contact_no"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "remarks", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.text "remark"
    t.string "remarkable_type", null: false
    t.bigint "remarkable_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["remarkable_type", "remarkable_id"], name: "index_remarks_on_remarkable"
    t.index ["user_id"], name: "index_remarks_on_user_id"
  end

  create_table "sip_abs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.integer "min_age"
    t.integer "max_age"
    t.integer "insured_type"
    t.integer "exit_age"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sip_pbs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "sip_ab_id"
    t.bigint "benefit_id"
    t.decimal "coverage_amount", precision: 15, scale: 2
    t.decimal "premium", precision: 15, scale: 2
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "plan_unit_id"
    t.index ["benefit_id"], name: "index_sip_pbs_on_benefit_id"
    t.index ["plan_unit_id"], name: "index_sip_pbs_on_plan_unit_id"
    t.index ["sip_ab_id"], name: "index_sip_pbs_on_sip_ab_id"
  end

  create_table "special_arrangements", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "agreement_id"
    t.text "arrangement"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["agreement_id"], name: "index_special_arrangements_on_agreement_id"
  end

  create_table "treasury_accounts", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.integer "account_type"
    t.boolean "is_check_account", default: false
    t.string "contact_number"
    t.string "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "treasury_billing_statements", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "bs_no"
    t.date "bs_date"
    t.bigint "cashier_entry_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cashier_entry_id"], name: "index_treasury_billing_statements_on_cashier_entry_id"
  end

  create_table "treasury_business_checks", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "check_number"
    t.date "check_date"
    t.decimal "amount", precision: 15, scale: 2
    t.integer "check_type"
    t.bigint "voucher_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0
    t.text "notes"
    t.index ["voucher_id"], name: "index_treasury_business_checks_on_voucher_id"
  end

  create_table "treasury_cashier_entries", primary_key: ["id", "created_at"], charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "id", null: false, auto_increment: true
    t.integer "or_no"
    t.date "or_date"
    t.string "entriable_type", null: false
    t.bigint "entriable_id", null: false
    t.integer "status", default: 0
    t.bigint "treasury_account_id", null: false
    t.decimal "amount", precision: 15, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "vat", precision: 15, scale: 2, default: "0.0"
    t.decimal "discount", precision: 15, scale: 2, default: "0.0"
    t.decimal "net_amount", precision: 15, scale: 2, default: "0.0"
    t.decimal "withholding_tax", precision: 15, scale: 2, default: "0.0"
    t.boolean "vatable", default: false
    t.bigint "treasury_payment_type_id", null: false
    t.string "branch"
    t.index ["entriable_type", "entriable_id"], name: "index_treasury_cashier_entries_on_entriable"
    t.index ["treasury_account_id"], name: "index_treasury_cashier_entries_on_treasury_account_id"
    t.index ["treasury_payment_type_id"], name: "index_treasury_cashier_entries_on_treasury_payment_type_id"
  end

  create_table "treasury_payment_types", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "treasury_payments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "payment_type"
    t.integer "check_no"
    t.decimal "amount", precision: 15, scale: 2
    t.bigint "account_id", null: false
    t.bigint "cashier_entry_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_treasury_payments_on_account_id"
    t.index ["cashier_entry_id"], name: "index_treasury_payments_on_cashier_entry_id"
  end

  create_table "underwriting_routes", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "unit_benefits", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "plan_unit_id"
    t.bigint "benefit_id"
    t.decimal "coverage_amount", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["benefit_id"], name: "index_unit_benefits_on_benefit_id"
    t.index ["plan_unit_id"], name: "index_unit_benefits_on_plan_unit_id"
  end

  create_table "user_levels", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "authority_level_id"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["authority_level_id"], name: "index_user_levels_on_authority_level_id"
    t.index ["user_id"], name: "index_user_levels_on_user_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "userable_id"
    t.string "userable_type"
    t.boolean "admin", default: false
    t.boolean "approved", default: false
    t.integer "rank"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "accounting_vouchers", "check_voucher_requests"
  add_foreign_key "accounting_vouchers", "treasury_accounts"
  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "agreements_coop_members", "agreements"
  add_foreign_key "agreements_coop_members", "coop_members"
  add_foreign_key "anniversaries", "agreements"
  add_foreign_key "batch_beneficiaries", "batches"
  add_foreign_key "batch_beneficiaries", "member_dependents"
  add_foreign_key "batch_dependents", "agreement_benefits"
  add_foreign_key "batch_dependents", "batches"
  add_foreign_key "batch_dependents", "member_dependents"
  add_foreign_key "batch_group_remits", "batches"
  add_foreign_key "batch_group_remits", "group_remits"
  add_foreign_key "batches", "agreement_benefits"
  add_foreign_key "batches", "coop_members"
  add_foreign_key "claim_attachments", "claim_type_documents"
  add_foreign_key "claim_attachments", "process_claims"
  add_foreign_key "claim_causes", "process_claims"
  add_foreign_key "claim_payments", "process_claims"
  add_foreign_key "claim_remarks", "process_claims"
  add_foreign_key "claim_remarks", "users"
  add_foreign_key "claim_request_for_payments", "process_claims"
  add_foreign_key "coop_branches", "cooperatives"
  add_foreign_key "coop_members", "coop_branches"
  add_foreign_key "coop_members", "cooperatives"
  add_foreign_key "coop_members", "members"
  add_foreign_key "coop_users", "coop_branches"
  add_foreign_key "coop_users", "cooperatives"
  add_foreign_key "denied_dependents", "batches"
  add_foreign_key "denied_dependents", "group_remits"
  add_foreign_key "denied_enrollees", "cooperatives"
  add_foreign_key "denied_members", "group_remits"
  add_foreign_key "dependent_health_decs", "batch_dependents"
  add_foreign_key "dependent_remarks", "batch_dependents"
  add_foreign_key "emp_approvers", "employees", column: "approver_id"
  add_foreign_key "employees", "departments"
  add_foreign_key "general_ledgers", "treasury_accounts", column: "account_id"
  add_foreign_key "group_remits", "agreements"
  add_foreign_key "health_dec_subquestions", "health_decs"
  add_foreign_key "loan_insurance_batches", "coop_members"
  add_foreign_key "loan_insurance_batches", "group_remits"
  add_foreign_key "loan_insurance_batches", "loan_insurance_rates"
  add_foreign_key "loan_insurance_details", "batches"
  add_foreign_key "loan_insurance_details", "loan_insurance_loans"
  add_foreign_key "loan_insurance_details", "loan_insurance_rates"
  add_foreign_key "loan_insurance_details", "loan_insurance_retentions"
  add_foreign_key "loan_insurance_loans", "cooperatives"
  add_foreign_key "loan_insurance_rates", "agreements"
  add_foreign_key "member_dependents", "members"
  add_foreign_key "process_claims", "agreement_benefits"
  add_foreign_key "process_claims", "agreements"
  add_foreign_key "process_claims", "cooperatives"
  add_foreign_key "process_coverages", "employees", column: "approver_id"
  add_foreign_key "process_coverages", "employees", column: "processor_id"
  add_foreign_key "process_coverages", "employees", column: "who_approved_id"
  add_foreign_key "process_coverages", "employees", column: "who_processed_id"
  add_foreign_key "process_tracks", "users"
  add_foreign_key "product_benefits", "agreement_benefits"
  add_foreign_key "product_benefits", "benefits"
  add_foreign_key "sip_pbs", "plan_units"
  add_foreign_key "treasury_billing_statements", "treasury_cashier_entries", column: "cashier_entry_id"
  add_foreign_key "treasury_business_checks", "accounting_vouchers", column: "voucher_id"
  add_foreign_key "treasury_cashier_entries", "treasury_accounts"
  add_foreign_key "treasury_cashier_entries", "treasury_payment_types"
  add_foreign_key "treasury_payments", "treasury_accounts", column: "account_id"
  add_foreign_key "treasury_payments", "treasury_cashier_entries", column: "cashier_entry_id"
end
