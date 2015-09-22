feature 'update category' do
  
  before do
    @transaction2 = FactoryGirl.create :expense_transaction, description: 'Itsu', date: Time.parse('2015-01-01')
    FactoryGirl.create :expense_transaction, description: 'Gov', date: Time.parse('2015-01-01')
    @transaction = FactoryGirl.create :income_transaction, description: 'Itsu', date: Time.parse('2015-02-01')
  end

  context 'when I hit apply to similar' do

    context 'and the similar transaction has no category' do
      
      before do
        @transaction.update_attributes! category: 'whatever'

        visit transactions_path

        click_on 'Apply to similar'
      end

      it 'should update transactions that have the same description' do
        expect(Transaction.where(category: 'whatever').count).to eq 2
        expect(Transaction.where(category: nil).count).to eq 1
      end

    end

    context 'and the similar transaction has a category' do
      
      before do
        @transaction.update_attributes! category: 'whatever'
        @transaction2.update_attributes! category: 'something'

        visit transactions_path

        within :css, ".transaction-row-#{@transaction.id}" do
          click_on 'Apply to similar'
        end

      end

      it 'should not update transactions that have the same description' do
        expect(Transaction.where(category: 'whatever').count).to eq 1
      end

    end

    context 'and the transactions have no description' do
      
      before do
        @transaction.update_attributes! category: 'whatever'
        
        Transaction.update_all description: nil

        visit transactions_path

        click_on 'Apply to similar'
      end

      it 'should not update other transactions with no description' do
        expect(Transaction.where(category: 'whatever').count).to eq 1
      end

    end

  end

  context 'when I update the category' do

    before do
      visit transactions_path
      
      within :css, ".transaction-row-#{@transaction.id}" do
        select('haircut', from: :transaction_category)
        click_on 'add category'
      end
    end

    it 'should save and render the label', js: true do
      expect(find('span.label.label-default').text).to eq 'haircut'
      expect(Transaction.find(@transaction.id).category).to eq 'haircut'
    end

  end

end