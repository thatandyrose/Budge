describe Transaction do
  let!(:uri){ File.join Rails.root, 'spec', 'scafolding', 'barclays_export_dates.csv' }

  context 'when the csv have dates from last year and this and I import' do
    before do
      Transaction.import(:barclays, uri)

      @vue_transaction = Transaction.find_by(description: 'VUE BSL LTD')
      @spotify_transaction = Transaction.find_by(description: 'SPOTIFY SPOTIFY PR')
    end

    it 'should import dates with the correct years' do
      expect(@vue_transaction.date.to_s).to eq "2015-01-05"
      expect(@spotify_transaction.date.to_s).to eq "2014-12-28"
    end

    it 'should store original dates' do
      expect(@vue_transaction.original_date.to_s).to eq "2015-01-10"
      expect(@spotify_transaction.original_date.to_s).to eq "2015-01-10"
    end
  end

end
