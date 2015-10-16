feature 'transactions index' do
  
  before do
    FactoryGirl.create :expense_transaction, description: 'some expense', date: Time.parse('2015-01-01')
    FactoryGirl.create :income_transaction, description: 'some income', date: Time.parse('2015-02-01')
  end
  
  context 'when I visit the page' do
    
    before do
      visit transactions_path
    end

    it 'should show me my transactions' do
      expect(page.status_code).to eq 200
      expect(page).to have_content 'some expense'
      expect(page).to_not have_content 'some income'
    end
  end

  context 'when I visit the page and hit the income tab' do
    before do
      visit transactions_path
      click_on 'Incomes'
    end

    it 'should show me my transactions' do
      expect(page.status_code).to eq 200
      expect(page).to_not have_content 'some expense'
      expect(page).to have_content 'some income'
    end
  end

  context 'when I visit the page and pass a month' do
    
    before do
      visit transactions_path(month: '2015-01-23')
    end

    it 'should show me my transactions for that month only' do
      expect(page.status_code).to eq 200
      expect(page).to have_content 'some expense'
      expect(page).to_not have_content 'some income'
    end
  end
  

end