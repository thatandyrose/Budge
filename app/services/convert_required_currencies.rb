class ConvertRequiredCurrencies
  def call
    batch_update
  end

  def transactions_to_update
    Transaction
      .where.not(amount_non_gbp:nil)
      .where.not(non_gbp_currency: nil)
      .where(amount: nil)
      .order(date: :asc)
  end

  def batch_update
    if transactions_to_update.count > 0
      transactions = transactions_to_update.limit(100).to_a
      rates = get_rates(transactions)

      transactions.each do |t|
        t.amount = t.amount_non_gbp.to_d * rate_for_day(rates, t.date.to_date.to_s).round(2)
        t.save!
      end

      batch_update
    end
  end

  def get_rates(transactions)
    start_date = transactions.first.date.to_date.to_s
    end_date = transactions.last.date.to_date.to_s

    EurToGbpConverter.new.rates_for_range start_date, end_date
  end

  def rate_for_day(rates, date_string)
    rate_object = rates.select{|r|r[:date] == date_string}.first

    if rate_object
      rate_object[:rate]
    else
      before_rate = rates.select{|r| Date.parse(r[:date]) < Date.parse(date_string)}.last || {date: Date.parse(date_string) - 10.years}
      after_rate = rates.select{|r| Date.parse(r[:date]) > Date.parse(date_string)}.first || {date: Date.parse(date_string) + 10.years}

      [before_rate, after_rate].sort_by{|r| (Date.parse(r[:date]) - Date.parse(date_string)).to_i.abs}.first[:rate]
    end
  end
end