describe ConvertRequiredCurrencies do
  before do
    allow_any_instance_of(EurToGbpConverter)
      .to receive(:rates_for_range)
      .and_return([
        {
          date: '2020-01-10',
          rate: 1.5
        },
        {
          date: '2020-01-20',
          rate: 1.9
        }
      ])

      FactoryGirl.create :expense_transaction, amount: 1, date: '2020-01-10'
      FactoryGirl.create :expense_transaction, amount: 2, amount_non_gbp: 1000, non_gbp_currency: 'EUR', date: '2020-01-10'
      FactoryGirl.create :expense_transaction, amount: 0, amount_non_gbp: 2000, non_gbp_currency: 'EUR', date: '2020-01-10'
      FactoryGirl.create :expense_transaction, amount: nil, amount_non_gbp: 3, non_gbp_currency: 'EUR', date: '2020-01-10'
      FactoryGirl.create :expense_transaction, amount: nil, amount_non_gbp: nil, non_gbp_currency: 'EUR', date: '2020-01-10'
      FactoryGirl.create :expense_transaction, amount: nil, amount_non_gbp: 3000, non_gbp_currency: nil, date: '2020-01-10'

      FactoryGirl.create :income_transaction, amount: nil, amount_non_gbp: 4, non_gbp_currency: 'EUR', date: '2019-01-10'
      FactoryGirl.create :income_transaction, amount: nil, amount_non_gbp: 5, non_gbp_currency: 'EUR', date: '2020-01-10'
      FactoryGirl.create :income_transaction, amount: nil, amount_non_gbp: 6, non_gbp_currency: 'EUR', date: '2020-01-12'
      FactoryGirl.create :income_transaction, amount: nil, amount_non_gbp: 7, non_gbp_currency: 'EUR', date: '2020-01-18'
      FactoryGirl.create :income_transaction, amount: nil, amount_non_gbp: 8, non_gbp_currency: 'EUR', date: '2020-01-20'
      FactoryGirl.create :income_transaction, amount: nil, amount_non_gbp: 9, non_gbp_currency: 'EUR', date: '2020-01-21'
      FactoryGirl.create :income_transaction, amount: nil, amount_non_gbp: 10, non_gbp_currency: 'EUR', date: '2022-01-21'
  end

  it 'should correctly convert the records that need it' do
    ConvertRequiredCurrencies.new.batch_update

    expect(Transaction.order(date: :asc).pluck :amount).to_eq([
      1, 2, 0, 4.5, nil, nil, 6, 7.5, 9, 13.3, 15.2, 17.1, 19
    ])
  end

end
