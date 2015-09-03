describe Transaction do
  let!(:uri){ File.join Rails.root, 'spec', 'scafolding', 'barclays_export.csv' }
  let!(:uri2){ File.join Rails.root, 'spec', 'scafolding', 'barclays_export2.csv' }

  describe 'multiple imports' do
    before do
      Transaction.import(:barclays, uri)
      Transaction.import(:barclays, uri2)
    end

    it 'should import the additional records' do
      expect(Transaction.count).to eq 6

      expect(Transaction.incomes.pluck(:amount).sum).to eq 95
      expect(Transaction.expenses.pluck(:amount).sum).to eq 126.99
    end
  end
  
  describe 'import barclyas' do

    before do
      Transaction.import(:barclays, uri)
    end

    it 'should import all records' do
      expect(Transaction.count).to eq 4
    end

    it 'should import incomes' do
      expect(Transaction.incomes.count).to eq 1

      t = Transaction.incomes.find_by(date: Date.parse('2015-04-17') ) 

      expect(t.amount).to eq 95
      expect(t.description).to eq "DIRECTDEP: A Kalo MONKEY FACE BGC"
    end

    it 'should import expenses' do
      expect(Transaction.expenses.count).to eq 3

      t1 = Transaction.expenses.find_by(date: Date.parse('2015-04-14'))
      t2 = Transaction.expenses.find_by(date: Date.parse('2015-04-15'))
      t3 = Transaction.expenses.find_by(date: Date.parse('2015-04-16'))

      expect(t1.amount).to eq 52.85
      expect(t2.amount).to eq 27.08
      expect(t3.amount).to eq 9.99

      expect(t1.description).to eq "CASH: POSTE ITALIANE ITALY"
      expect(t2.description).to eq "PAYMENT: VUE BSL LTD ON 25 JUN BCC"
      expect(t3.description).to eq "PAYMENT: SPOTIFY SPOTIFY PR ON 25 JUN BCC"
    end
  end

end