feature 'apply to similar ui' do

  before do
    @transaction2 = FactoryGirl.create :expense_transaction, description: 'Itsu', date: Time.parse('2015-01-01')
    FactoryGirl.create :expense_transaction, description: 'Gov', date: Time.parse('2015-01-01')
    @transaction = FactoryGirl.create :expense_transaction, description: 'Itsu', date: Time.parse('2015-02-01')
  end

  context 'when one transaction has a category' do
    
    before do
      @transaction.update_attributes! category: 'whatever'
    end

    context 'and none of the transactions have descriptions' do

      before do
        @transaction.update_attributes! category: 'whatever'
        Transaction.update_all description: nil
      end

      context 'and I click apply to similar' do
        
        before do
          visit transactions_path
          click_on 'Apply to similar'
        end

        it 'should not update other transactions with no description' do
          expect(Transaction.where(category: 'whatever').count).to eq 1
        end

      end

    end

    context 'and the similar transaction has a category too' do
      
      before do
        @transaction2.update_attributes! category: 'something'
      end

      context 'and I click apply to similar' do

        before do
          visit transactions_path
          
          within :css, ".transaction-row-#{@transaction.id}" do
            click_on 'Apply to similar'
          end

          @transaction.reload
        end

        it 'should not update transactions that have the same description' do
          expect(Transaction.where(category: 'whatever').count).to eq 1
        end

      end

    end

    context 'and I click apply to similar' do
      
      before do
        visit transactions_path
        click_on 'Apply to similar'

        @transaction.reload
      end

      it 'should update transactions that have the same description' do
        expect(Transaction.where(category: 'whatever').count).to eq 2
        expect(Transaction.where(category: nil).count).to eq 1
      end

    end

  end

end