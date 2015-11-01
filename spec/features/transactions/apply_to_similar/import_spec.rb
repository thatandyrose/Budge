feature 'apply to similar import' do
  let!(:uri){ File.join Rails.root, 'spec', 'scafolding', 'barclays_export.csv' }

  context 'when I have one transaction with a description', js:true do

    before do
      @transaction = FactoryGirl.create :expense_transaction, description: 'POSTE ITALIANE ITALY', date: Time.parse('2015-02-01')
    end

    context 'and I add a category to it' do

      before do
        visit transactions_path
        select 'haircut', from: :transaction_category
        wait_for_ajax
      end

      context 'and then I hit apply to similar' do

        before do
          click_on 'Apply to similar'
          wait_for_ajax
        end

        context 'and then I import a transaction with a similar description' do
        
          before do
            Transaction.import(:barclays, uri)
          end

          it 'should update the newly imported transaction with the category' do
            expect(Transaction.where(description: 'POSTE ITALIANE ITALY').pluck(:category).select(&:present?).count).to eq 2
          end

        end

      end

      context 'and then I import a transaction with a similar description' do
        
        before do
          Transaction.import(:barclays, uri)
        end

        it 'should not update the newly imported transaction with the category' do
          expect(Transaction.where(description: 'POSTE ITALIANE ITALY').pluck(:category).select(&:present?).count).to eq 1
        end

      end

    end

  end

end