class ConvertRequiredCurrencies
  def call
    puts "Starting currency conversion"
    batch_update
    puts "Done"
  end

  def transactions_to_update
    Transaction
      .where.not(amount_non_gbp:nil)
      .where.not(non_gbp_currency: nil)
      .where(amount: nil)
  end

  def sql_months
    transactions_to_update
    .select("distinct(date_trunc('month', date)) as m")
    .order("m asc").map &:m
  end

  def transactions_for_month(sql_month)
    transactions_to_update
      .where("date_trunc('month', date) = ?", sql_month)
      .order(date: :asc)
  end

  def batch_update
    count = transactions_to_update.count

    if count > 0
      sql_months.each do |sql_month|
        transactions = transactions_for_month(sql_month).to_a
        rates = get_rates(transactions)

        transactions.each do |t|
          rate = rate_for_day rates, t.date.to_date.to_s
          t.amount = (t.amount_non_gbp.to_d * rate).round(2)
          puts "Month: #{sql_month}, rate: #{rate}, old amount: #{t.amount_non_gbp}, new amount: #{t.amount}"
          t.save!
        end
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
      before_rate = rates.select{|r| Date.parse(r[:date]) < Date.parse(date_string)}.last || {date: (Date.parse(date_string) - 10.years).to_s}
      after_rate = rates.select{|r| Date.parse(r[:date]) > Date.parse(date_string)}.first || {date: (Date.parse(date_string) + 10.years).to_s}

      [before_rate, after_rate].sort_by{|r| (Date.parse(r[:date]) - Date.parse(date_string)).to_i.abs}.first[:rate]
    end
  end
end