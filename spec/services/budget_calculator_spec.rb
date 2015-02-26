describe BudgetCalculator do
  
  context 'where there has been two credits in the last two months' do
    
    before do
      FactoryGirl.create :income_transaction, amount:30, date: 60.days.ago
      FactoryGirl.create :income_transaction, amount:15, date: Time.now
    end

    it 'should calculate per day budget 30 days in advance' do
      expect(BudgetCalculator.new().per_day_ahead).to eq 0.5
    end

  end

end