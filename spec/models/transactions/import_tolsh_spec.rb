describe Transaction do
  let!(:uri){ File.join Rails.root, 'spec', 'scafolding', 'toshl_export.csv' }

  describe 'import tolsh' do

    before do
      Transaction.import(:tolsh, uri)
    end

    it 'should import all records' do
      expect(Transaction.count).to eq 4
    end

    it 'should import incomes' do
      expect(Transaction.incomes.count).to eq 2

      t1 = Transaction.incomes.find_by(date: Date.parse('2015-04-14'))
      t2 = Transaction.incomes.find_by(date: Date.parse('2015-04-15'))

      expect(t1.amount).to eq 100
      expect(t2.amount).to eq 200.65

      expect(t1.tags).to include('Salary 1')
      expect(t2.tags).to include('Salary 2')
    end

    it 'should import expenses' do
      expect(Transaction.expenses.count).to eq 2

      t1 = Transaction.expenses.find_by(date: Date.parse('2015-04-12'))
      t2 = Transaction.expenses.find_by(date: Date.parse('2015-04-13'))

      expect(t1.amount).to eq 20
      expect(t2.amount).to eq 6.5

      expect(t1.tags).to include('public transport')
      expect(t2.tags).to include('food and drink')
    end
  end

end