feature 'income' do
  
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

      within(:css, '.budget-data') do
        expect(page).to have_content '$0.0 / $0.0'
      end

    end

  end

  context 'when I have income from 2 months ago' do

    before do
      FactoryGirl.create :income_transaction, date: 2.months.ago
      FactoryGirl.create :income_transaction, date: 2.months.ago
      FactoryGirl.create :income_transaction, date: 2.months.ago

      visit root_path
    end

    it 'should show yearly data and recent data' do

      within(:css, '.budget-data') do
        expect(page).to have_content '$0.33 / $0.12'
      end

    end

  end

  context 'when I have income from 4 months ago' do

    before do
      FactoryGirl.create :income_transaction, date: 4.months.ago
      FactoryGirl.create :income_transaction, date: 4.months.ago
      FactoryGirl.create :income_transaction, date: 4.months.ago

      visit root_path
    end

    it 'should show yearly data and no recent data' do

      within(:css, '.budget-data') do
        expect(page).to have_content '$0.0 / $0.12'
      end

    end

  end

end