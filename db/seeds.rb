# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
# AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?
# Cooperative.create!(name:'Coop 1', description:'Coop 1 Multi-purpose cooperative', contact_details:'09123456789', region:'Region 1', province:'Province 1', municipality:'Municipality 1', barangay:'Barangay 1', street:'Street 1', acronym: 'COOP1', cooperative_type: 'Multi-purpose', registration_number: 123456789, tin_number: 123456789)
CoopBranch.create!(name: 'Branch 1', cooperative_id: 1, region: "Region 1", province: "Province 1", municipality: "Municipality 1", barangay: "Barangay 1", street: "Street 1", contact_details: "09123456789")
