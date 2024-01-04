FactoryBot.define do
  factory :payment do
    receipt { FFaker.numerify('###-###-###') }
    status { 0 }
    amount { 850 }

    association :payable, factory: :remittance
  end
end
