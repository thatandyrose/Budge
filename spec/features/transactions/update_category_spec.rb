feature 'update category' do
  
  before do
    @transaction2 = FactoryGirl.create :expense_transaction, description: 'Itsu', date: Time.parse('2015-01-01')
    FactoryGirl.create :expense_transaction, description: 'Gov', date: Time.parse('2015-01-01')
    @transaction = FactoryGirl.create :expense_transaction, description: 'Itsu', date: Time.parse('2015-02-01')
  end

  context 'when I update the category', js:true do

    before do
      visit transactions_path
      
      within :css, ".transaction-row-#{@transaction.id}" do
        select('haircut', from: :transaction_category)
        wait_for_ajax
      end
    end

    it 'should save and render the label', js: true do
      expect(find('span.label.label-default').text).to eq 'haircut'
      expect(Transaction.find(@transaction.id).category).to eq 'haircut'
    end

  end

end