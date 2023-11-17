FactoryBot.define do
  factory :batch, class: "LoanInsurance::Batch" do
    coop_member
    group_remit
    loan
    rate
    # retention

    loan_amount { 100_000 }
    terms { 12 }
    date_release { Date.today }
    date_mature { Date.today + 1.year }
    effectivity_date { Date.today }
    expiry_date { Date.today + 1.year }
    premium { 1000 }
    coop_sf_amount { 10 }
    agent_sf_amount { 5 }
    age { coop_member.member.age(effectivity_date) }
    insurance_status { :for_review }
  end
end
