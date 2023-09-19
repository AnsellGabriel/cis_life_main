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

ActiveRecord::Schema[7.0].define(version: 2023_09_12_081208) do
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "agent_group_id", null: false
    t.index ["agent_group_id"], name: "index_agents_on_agent_group_id"
  end

  create_table "agreement_benefits", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "agreement_id"
    t.bigint "plan_id"
    t.bigint "proposal_id"
    t.bigint "option_id"
    t.string "name"
    t.text "description"
    t.decimal "min_age", precision: 10, scale: 3
    t.decimal "max_age", precision: 10, scale: 3
    t.integer "insured_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "exit_age", precision: 10, scale: 3
    t.boolean "with_dependent"
    t.index ["agreement_id"], name: "index_agreement_benefits_on_agreement_id"
    t.index ["option_id"], name: "index_agreement_benefits_on_option_id"
    t.index ["plan_id"], name: "index_agreement_benefits_on_plan_id"
    t.index ["proposal_id"], name: "index_agreement_benefits_on_proposal_id"
  end

  create_table "agreements", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "plan_id"
    t.bigint "cooperative_id"
    t.bigint "agent_id"
    t.string "moa_no"
    t.integer "contestability"
    t.decimal "nel", precision: 12, scale: 2
    t.decimal "nml", precision: 12, scale: 2
    t.string "anniversary_type"
    t.boolean "transferred"
    t.date "transferred_date"
    t.string "previous_provider"
    t.string "comm_type"
    t.boolean "claims_fund"
    t.integer "entry_age_from"
    t.integer "entry_age_to"
    t.integer "exit_age"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "proposal_id", null: false
    t.string "description"
    t.decimal "coop_sf", precision: 10, scale: 2
    t.decimal "agent_sf", precision: 10, scale: 2
    t.integer "minimum_participation"
    t.decimal "claims_fund_amount", precision: 10, scale: 2
    t.boolean "reconsiderable", default: false
    t.index ["agent_id"], name: "index_agreements_on_agent_id"
    t.index ["cooperative_id"], name: "index_agreements_on_cooperative_id"
    t.index ["plan_id"], name: "index_agreements_on_plan_id"
    t.index ["proposal_id"], name: "index_agreements_on_proposal_id"
  end

  create_table "agreements_coop_members", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "agreement_id", null: false
    t.bigint "coop_member_id", null: false
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "effectivity"
    t.date "expiry"
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

  create_table "batch_health_decs", charset: "utf8mb4", force: :cascade do |t|
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

  create_table "batch_remarks", charset: "utf8mb4", force: :cascade do |t|
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
    t.float "coop_sf_amount"
    t.float "agent_sf_amount"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "premium", precision: 10, scale: 2
    t.bigint "coop_member_id", null: false
    t.boolean "transferred"
    t.bigint "agreement_benefit_id", null: false
    t.boolean "valid_health_dec", default: false
    t.integer "age"
    t.integer "insurance_status", default: 3
    t.boolean "below_nel", default: false
    t.integer "duration"
    t.integer "residency"
    t.date "previous_effectivity_date"
    t.date "previous_expiry_date"
    t.index ["agreement_benefit_id"], name: "index_batches_on_agreement_benefit_id"
    t.index ["coop_member_id"], name: "index_batches_on_coop_member_id"
  end

  create_table "benefits", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "acronym"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "causes", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "claim_remarks", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "process_claim_id", null: false
    t.bigint "user_id", null: false
    t.string "status"
    t.text "remark"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "coop"
    t.index ["process_claim_id"], name: "index_claim_remarks_on_process_claim_id"
    t.index ["user_id"], name: "index_claim_remarks_on_user_id"
  end

  create_table "claim_type_benefits", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "claim_type_id"
    t.bigint "benefit_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["benefit_id"], name: "index_claim_type_benefits_on_benefit_id"
    t.index ["claim_type_id"], name: "index_claim_type_benefits_on_claim_type_id"
  end

  create_table "claim_type_documents", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "claim_type_id"
    t.bigint "document_id"
    t.boolean "required"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["claim_type_id"], name: "index_claim_type_documents_on_claim_type_id"
    t.index ["document_id"], name: "index_claim_type_documents_on_document_id"
  end

  create_table "claim_types", charset: "utf8mb4", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "coop_branches", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "region"
    t.string "province"
    t.string "municipality"
    t.string "barangay"
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
    t.string "contact_details"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.string "registration_number"
    t.integer "tin_number"
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

  create_table "dependent_health_decs", charset: "utf8mb4", force: :cascade do |t|
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
    t.index ["user_id"], name: "index_dependent_remarks_on_user_id"
    t.index ["userable_type", "userable_id"], name: "index_dependent_remarks_on_userable"
  end

  create_table "documents", charset: "utf8mb4", force: :cascade do |t|
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

  create_table "emp_approvers", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "employee_id"
    t.bigint "approver_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["approver_id"], name: "index_emp_approvers_on_approver_id"
    t.index ["employee_id"], name: "index_emp_approvers_on_employee_id"
  end

  create_table "employees", charset: "utf8mb4", force: :cascade do |t|
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
    t.index ["department_id"], name: "index_employees_on_department_id"
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

  create_table "group_import_trackers", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.float "progress"
    t.bigint "group_remit_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_remit_id"], name: "index_group_import_trackers_on_group_remit_id"
  end

  create_table "group_remits", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.text "description"
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
    t.bigint "loan_insurance_loan_id", null: false
    t.integer "insurance_status"
    t.integer "status"
    t.boolean "terminated"
    t.date "terminate_date"
    t.integer "unused_loan_id"
    t.boolean "substandard", default: false
    t.decimal "excess", precision: 10, scale: 2, default: "0.0"
    t.index ["coop_member_id"], name: "index_loan_insurance_batches_on_coop_member_id"
    t.index ["group_remit_id"], name: "index_loan_insurance_batches_on_group_remit_id"
    t.index ["loan_insurance_loan_id"], name: "index_loan_insurance_batches_on_loan_insurance_loan_id"
    t.index ["loan_insurance_rate_id"], name: "index_loan_insurance_batches_on_loan_insurance_rate_id"
  end

  create_table "loan_insurance_details", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "batch_id", null: false
    t.decimal "unuse", precision: 10, scale: 2
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

  create_table "member_import_trackers", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.float "progress"
    t.bigint "coop_user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["coop_user_id"], name: "index_member_import_trackers_on_coop_user_id"
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

  create_table "payments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "receipt"
    t.bigint "group_remit_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_remit_id"], name: "index_payments_on_group_remit_id"
  end

  create_table "plans", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "entry_age_from"
    t.integer "entry_age_to"
    t.integer "exit_age"
    t.integer "min_participation"
    t.string "acronym"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "gyrt_type"
  end

  create_table "process_claims", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "cooperative_id", null: false
    t.bigint "agreement_id", null: false
    t.date "date_incident"
    t.string "entry_type"
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
    t.index ["agent_id"], name: "index_process_coverages_on_agent_id"
    t.index ["approver_id"], name: "index_process_coverages_on_approver_id"
    t.index ["group_remit_id"], name: "index_process_coverages_on_group_remit_id"
    t.index ["processor_id"], name: "index_process_coverages_on_processor_id"
    t.index ["und_route"], name: "index_process_coverages_on_und_route"
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

  create_table "process_routes", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "department"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "proposals", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "cooperative_id", null: false
    t.integer "ave_age"
    t.decimal "total_premium", precision: 10, scale: 2
    t.decimal "coop_sf", precision: 10, scale: 2
    t.decimal "agent_sf", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "minimum_participation"
    t.string "proposal_no"
    t.index ["cooperative_id"], name: "index_proposals_on_cooperative_id"
  end

  create_table "reinsurance_batches", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "reinsurance_id"
    t.bigint "batch_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["batch_id"], name: "index_reinsurance_batches_on_batch_id"
    t.index ["reinsurance_id"], name: "index_reinsurance_batches_on_reinsurance_id"
  end

  create_table "reinsurances", charset: "utf8mb4", force: :cascade do |t|
    t.date "date_from"
    t.date "date_to"
    t.decimal "ri_total_amount", precision: 10
    t.decimal "ri_total_prem", precision: 10
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "requirements", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "underwriting_routes", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "agents", "agent_groups"
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
  add_foreign_key "claim_remarks", "process_claims"
  add_foreign_key "claim_remarks", "users"
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
  add_foreign_key "group_import_trackers", "group_remits"
  add_foreign_key "group_remits", "agreements"
  add_foreign_key "health_dec_subquestions", "health_decs"
  add_foreign_key "loan_insurance_batches", "coop_members"
  add_foreign_key "loan_insurance_batches", "group_remits"
  add_foreign_key "loan_insurance_batches", "loan_insurance_loans"
  add_foreign_key "loan_insurance_batches", "loan_insurance_rates"
  add_foreign_key "loan_insurance_details", "batches"
  add_foreign_key "loan_insurance_details", "loan_insurance_loans"
  add_foreign_key "loan_insurance_details", "loan_insurance_rates"
  add_foreign_key "loan_insurance_details", "loan_insurance_retentions"
  add_foreign_key "loan_insurance_loans", "cooperatives"
  add_foreign_key "loan_insurance_rates", "agreements"
  add_foreign_key "member_dependents", "members"
  add_foreign_key "member_import_trackers", "coop_users"
  add_foreign_key "payments", "group_remits"
  add_foreign_key "process_claims", "agreement_benefits"
  add_foreign_key "process_claims", "agreements"
  add_foreign_key "process_claims", "cooperatives"
  add_foreign_key "process_coverages", "employees", column: "approver_id"
  add_foreign_key "process_coverages", "employees", column: "processor_id"
  add_foreign_key "process_tracks", "users"
  add_foreign_key "product_benefits", "agreement_benefits"
  add_foreign_key "product_benefits", "benefits"
  add_foreign_key "proposals", "cooperatives"
end
