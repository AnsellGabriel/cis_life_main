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

ActiveRecord::Schema[7.0].define(version: 2023_06_27_064952) do
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
    t.integer "min_age"
    t.integer "max_age"
    t.integer "insured_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "exit_age"
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
    t.index ["agent_id"], name: "index_agreements_on_agent_id"
    t.index ["cooperative_id"], name: "index_agreements_on_cooperative_id"
    t.index ["plan_id"], name: "index_agreements_on_plan_id"
    t.index ["proposal_id"], name: "index_agreements_on_proposal_id"
  end

  create_table "agreements_coop_members", id: false, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "agreement_id", null: false
    t.bigint "coop_member_id", null: false
    t.index ["agreement_id", "coop_member_id"], name: "index_agreements_coop_members_on_agreement_id_and_coop_member_id"
    t.index ["coop_member_id", "agreement_id"], name: "index_agreements_coop_members_on_coop_member_id_and_agreement_id"
  end

  create_table "anniversaries", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.date "anniversary_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "agreement_id", null: false
    t.index ["agreement_id"], name: "index_anniversaries_on_agreement_id"
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
    t.index ["agreement_benefit_id"], name: "index_batch_dependents_on_agreement_benefit_id"
    t.index ["batch_id"], name: "index_batch_dependents_on_batch_id"
    t.index ["member_dependent_id"], name: "index_batch_dependents_on_member_dependent_id"
  end

  create_table "batch_health_decs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "batch_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "answer"
    t.string "answerable_type", null: false
    t.bigint "answerable_id", null: false
    t.index ["answerable_type", "answerable_id"], name: "index_batch_health_decs_on_answerable"
    t.index ["batch_id"], name: "index_batch_health_decs_on_batch_id"
  end

  create_table "batch_remarks", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "batch_id", null: false
    t.text "remark"
    t.integer "status"
    t.string "user_type", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["batch_id"], name: "index_batch_remarks_on_batch_id"
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
    t.integer "age"
    t.integer "insurance_status", default: 3
    t.bigint "coop_member_id", null: false
    t.bigint "group_remit_id", null: false
    t.boolean "transferred"
    t.bigint "agreement_benefit_id", null: false
    t.boolean "valid_health_dec", default: false
    t.index ["agreement_benefit_id"], name: "index_batches_on_agreement_benefit_id"
    t.index ["coop_member_id"], name: "index_batches_on_coop_member_id"
    t.index ["group_remit_id"], name: "index_batches_on_group_remit_id"
  end

  create_table "benefits", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "acronym"
    t.string "description"
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
    t.index ["cooperative_id"], name: "index_coop_branches_on_cooperative_id"
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
    t.string "region"
    t.string "province"
    t.string "municipality"
    t.string "barangay"
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
    t.string "region"
    t.string "province"
    t.string "municipality"
    t.string "barangay"
    t.string "street"
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
    t.bigint "batch_id", null: false
    t.date "date_incident"
    t.string "entry_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "batch_beneficiary_id"
    t.index ["agreement_id"], name: "index_process_claims_on_agreement_id"
    t.index ["batch_beneficiary_id"], name: "index_process_claims_on_batch_beneficiary_id"
    t.index ["batch_id"], name: "index_process_claims_on_batch_id"
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
    t.bigint "underwriting_route_id"
    t.index ["agent_id"], name: "index_process_coverages_on_agent_id"
    t.index ["group_remit_id"], name: "index_process_coverages_on_group_remit_id"
    t.index ["underwriting_route_id"], name: "index_process_coverages_on_underwriting_route_id"
  end

  create_table "process_remarks", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "process_coverage_id"
    t.text "remark"
    t.string "status"
    t.string "user_type"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["process_coverage_id"], name: "index_process_remarks_on_process_coverage_id"
    t.index ["user_type", "user_id"], name: "index_process_remarks_on_user"
  end

  create_table "product_benefits", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.decimal "coverage_amount", precision: 10, scale: 2
    t.decimal "premium", precision: 10, scale: 2
    t.bigint "agreement_benefit_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "benefit_id", null: false
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

  create_table "underwriting_routes", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "agents", "agent_groups"
  add_foreign_key "agreements", "proposals"
  add_foreign_key "anniversaries", "agreements"
  add_foreign_key "batch_beneficiaries", "batches"
  add_foreign_key "batch_beneficiaries", "member_dependents"
  add_foreign_key "batch_dependents", "agreement_benefits"
  add_foreign_key "batch_dependents", "batches"
  add_foreign_key "batch_dependents", "member_dependents"
  add_foreign_key "batch_health_decs", "batches"
  add_foreign_key "batch_remarks", "batches"
  add_foreign_key "batches", "agreement_benefits"
  add_foreign_key "batches", "coop_members"
  add_foreign_key "batches", "group_remits"
  add_foreign_key "coop_branches", "cooperatives"
  add_foreign_key "coop_members", "coop_branches"
  add_foreign_key "coop_members", "cooperatives"
  add_foreign_key "coop_members", "members"
  add_foreign_key "coop_users", "coop_branches"
  add_foreign_key "coop_users", "cooperatives"
  add_foreign_key "denied_members", "group_remits"
  add_foreign_key "employees", "departments"
  add_foreign_key "group_remits", "agreements"
  add_foreign_key "health_dec_subquestions", "health_decs"
  add_foreign_key "member_dependents", "members"
  add_foreign_key "process_claims", "agreements"
  add_foreign_key "process_claims", "batches"
  add_foreign_key "process_claims", "cooperatives"
  add_foreign_key "product_benefits", "agreement_benefits"
  add_foreign_key "product_benefits", "benefits"
  add_foreign_key "proposals", "cooperatives"
end
