FactoryGirl.define do
  factory :transaction do
    date "2014-11-20"
    amount "9.99"
    tags "MyText"
    transaction_type "MyString"
    description "MyText"

    trait :income do
      transaction_type 'income'
    end

    factory :income_transaction, traits: [:income]
  end

end
