FactoryBot.define do 
  factory :batch, class: 'LoanInsurance::Batch' do
    coop_member
    agreement_benefit

    effectivity_date { Date.today }
    expiry_date { Date.today + 1.year }
    premium { 1000 }
    coop_sf_amount { 10 }
    agent_sf_amount { 5 }
    age { coop_member.member.age }

    after(:build) do |batch|
      batch.group_remits << build(:batch_remit)
    end
  end
end