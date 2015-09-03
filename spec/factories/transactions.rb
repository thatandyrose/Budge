FactoryGirl.define do
  factory :transaction do
    date { Time.now }
    amount 10
    description "MyText"

    trait :income do
      transaction_type 'income'
    end

    trait :expense do
      transaction_type 'expense'
    end

    factory :income_transaction, traits: [:income]
    factory :expense_transaction, traits: [:expense]
  end

end
