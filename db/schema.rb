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

ActiveRecord::Schema[7.0].define(version: 2023_05_10_073737) do
  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.integer "resource_id"
    t.string "author_type"
    t.integer "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

  create_table "admin_users", force: :cascade do |t|
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

  create_table "agent_groups", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "agents", force: :cascade do |t|
    t.string "last_name"
    t.string "first_name"
    t.string "middle_name"
    t.date "birthdate"
    t.string "mobile_number"
    t.integer "agent_group_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["agent_group_id"], name: "index_agents_on_agent_group_id"
  end

  create_table "agreement_benefits", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "coop_sf"
    t.decimal "agent_sf"
    t.decimal "premium"
  end

  create_table "agreements", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "premium"
    t.decimal "agent_service_fee"
    t.decimal "coop_service_fee"
    t.integer "plan_id", null: false
    t.integer "cooperative_id", null: false
    t.string "anniversary_type"
    t.string "agreement_type"
    t.index ["cooperative_id"], name: "index_agreements_on_cooperative_id"
    t.index ["plan_id"], name: "index_agreements_on_plan_id"
  end

  create_table "agreements_coop_members", id: false, force: :cascade do |t|
    t.integer "agreement_id", null: false
    t.integer "coop_member_id", null: false
    t.index ["agreement_id", "coop_member_id"], name: "index_agreements_coop_members_on_agreement_id_and_coop_member_id"
    t.index ["coop_member_id", "agreement_id"], name: "index_agreements_coop_members_on_coop_member_id_and_agreement_id"
  end

  create_table "anniversaries", force: :cascade do |t|
    t.string "name"
    t.date "anniversary_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "batch_beneficiaries", force: :cascade do |t|
    t.integer "batch_id", null: false
    t.integer "member_dependent_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["batch_id"], name: "index_batch_beneficiaries_on_batch_id"
    t.index ["member_dependent_id"], name: "index_batch_beneficiaries_on_member_dependent_id"
  end

  create_table "batch_dependents", force: :cascade do |t|
    t.integer "batch_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "member_dependent_id", null: false
    t.decimal "premium"
    t.decimal "coop_sf_amount"
    t.decimal "agent_sf_amount"
    t.index ["batch_id"], name: "index_batch_dependents_on_batch_id"
    t.index ["member_dependent_id"], name: "index_batch_dependents_on_member_dependent_id"
  end

  create_table "batches", force: :cascade do |t|
    t.date "effectivity_date"
    t.date "expiry_date"
    t.boolean "active"
    t.float "coop_sf_amount"
    t.float "agent_sf_amount"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "premium"
    t.integer "age"
    t.string "insurance_status"
    t.integer "coop_member_id", null: false
    t.integer "group_remit_id", null: false
    t.boolean "transferred"
    t.index ["coop_member_id"], name: "index_batches_on_coop_member_id"
    t.index ["group_remit_id"], name: "index_batches_on_group_remit_id"
  end

  create_table "coop_branches", force: :cascade do |t|
    t.string "name"
    t.string "region"
    t.string "province"
    t.string "municipality"
    t.string "barangay"
    t.string "contact_details"
    t.integer "cooperative_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.string "street"
    t.index ["cooperative_id"], name: "index_coop_branches_on_cooperative_id"
  end

  create_table "coop_members", force: :cascade do |t|
    t.integer "cooperative_id", null: false
    t.integer "coop_branch_id", null: false
    t.integer "member_id", null: false
    t.date "membership_date"
    t.boolean "transferred", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["coop_branch_id"], name: "index_coop_members_on_coop_branch_id"
    t.index ["cooperative_id"], name: "index_coop_members_on_cooperative_id"
    t.index ["member_id"], name: "index_coop_members_on_member_id"
  end

  create_table "coop_users", force: :cascade do |t|
    t.string "last_name"
    t.string "first_name"
    t.string "middle_name"
    t.date "birthdate"
    t.string "mobile_number"
    t.string "designation"
    t.integer "cooperative_id", null: false
    t.integer "coop_branch_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["coop_branch_id"], name: "index_coop_users_on_coop_branch_id"
    t.index ["cooperative_id"], name: "index_coop_users_on_cooperative_id"
  end

  create_table "cooperatives", force: :cascade do |t|
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

  create_table "departments", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "employees", force: :cascade do |t|
    t.string "last_name"
    t.string "first_name"
    t.string "middle_name"
    t.date "birthdate"
    t.string "employee_number"
    t.string "mobile_number"
    t.string "designation"
    t.integer "department_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["department_id"], name: "index_employees_on_department_id"
  end

  create_table "group_remits", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "agreement_id", null: false
    t.integer "anniversary_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "effectivity_date"
    t.date "expiry_date"
    t.integer "cooperative_id", null: false
    t.integer "terms"
    t.index ["agreement_id"], name: "index_group_remits_on_agreement_id"
    t.index ["anniversary_id"], name: "index_group_remits_on_anniversary_id"
    t.index ["cooperative_id"], name: "index_group_remits_on_cooperative_id"
  end

  create_table "member_dependents", force: :cascade do |t|
    t.string "last_name"
    t.string "first_name"
    t.string "middle_name"
    t.string "suffix"
    t.date "birth_date"
    t.string "relationship"
    t.integer "member_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["member_id"], name: "index_member_dependents_on_member_id"
  end

  create_table "members", force: :cascade do |t|
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

  create_table "plans", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "acronym"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
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
  add_foreign_key "agreements", "cooperatives"
  add_foreign_key "agreements", "plans"
  add_foreign_key "batch_beneficiaries", "batches"
  add_foreign_key "batch_beneficiaries", "member_dependents"
  add_foreign_key "batch_dependents", "batches"
  add_foreign_key "batch_dependents", "member_dependents"
  add_foreign_key "batches", "coop_members"
  add_foreign_key "batches", "group_remits"
  add_foreign_key "coop_branches", "cooperatives"
  add_foreign_key "coop_members", "coop_branches"
  add_foreign_key "coop_members", "cooperatives"
  add_foreign_key "coop_members", "members"
  add_foreign_key "coop_users", "coop_branches"
  add_foreign_key "coop_users", "cooperatives"
  add_foreign_key "employees", "departments"
  add_foreign_key "group_remits", "agreements"
  add_foreign_key "group_remits", "anniversaries"
  add_foreign_key "group_remits", "cooperatives"
  add_foreign_key "member_dependents", "members"
end
