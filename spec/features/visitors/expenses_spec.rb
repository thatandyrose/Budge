feature 'expenses' do

  before do
    Timecop.travel(Time.parse('2015-09-03'))
  end

  after do
    Timecop.return
  end
  
  context 'when I have no data' do

    before do
      visit root_path
    end

    it 'should not show any data' do
      
      within(:css, '.last-month') do
        expect(page).to have_content '$0.0'
      end

      within(:css, '.this-month') do
        expect(page).to have_content 'No data for the current month'
      end

    end

  end

  context 'when I have data for this month' do

    before do
      FactoryGirl.create :expense_transaction
      FactoryGirl.create :expense_transaction
      FactoryGirl.create :expense_transaction

      visit root_path
    end

    it 'should show data for this month' do
      
      within(:css, '.last-month') do
        expect(page).to have_content '$0.0'
      end

      within(:css, '.this-month') do
        expect(page).to have_content '$1.11'
        expect(page).to have_content '$30.0 spent so far'
      end

    end

  end

  context 'when I have data for last month' do

    before do
      FactoryGirl.create :expense_transaction, date: 1.months.ago
      FactoryGirl.create :expense_transaction, date: 1.months.ago
      FactoryGirl.create :expense_transaction, date: 1.months.ago

      visit root_path
    end

    it 'should show data for last month' do
      
      within(:css, '.last-month') do
        expect(page).to have_content '$1.0'
        expect(page).to have_content '$30.0 spent'
      end

      within(:css, '.this-month') do
        expect(page).to have_content 'No data for the current month'
      end

    end

  end

  context 'when I have data for 3 months ago' do

    before do
      FactoryGirl.create :expense_transaction, date: 3.months.ago
      FactoryGirl.create :expense_transaction, date: 3.months.ago
      FactoryGirl.create :expense_transaction, date: 3.months.ago

      visit root_path
    end

    it 'should not show any data' do
      
      within(:css, '.last-month') do
        expect(page).to have_content '$0.0'
      end

      within(:css, '.this-month') do
        expect(page).to have_content 'No data for the current month'
      end

    end

  end

end