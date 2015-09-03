class BudgetCalculator

  def initialize
    @end_date = Date.today
    @recent_days = 90
  end

  def transactions
    @transactions ||= Transaction.incomes.to_a
  end

  def recent_transactions
    @recent_transactions ||= Transaction.incomes.where(date: [@recent_days.days.ago..@end_date]).to_a
  end

  def year_transactions
    @year_transactions ||= Transaction.incomes.where(date: [@end_date.beginning_of_year..@end_date]).to_a
  end

  def total_income
    @total_income ||= calculate_income(transactions)
  end

  def calculate_income(_transactions)
    _transactions.map(&:amount).sum
  end

  def per_day_recent
    
    @per_day_recent ||= begin
      if recent_transactions.any?
        calculate_income(recent_transactions)/@recent_days
      else
        0
      end
    end

  end

  def per_day_year

    @per_day_year ||= begin
      if year_transactions.any?
        days = @end_date - @end_date.beginning_of_year
        calculate_income(year_transactions)/days
      else
        0
      end
    end

  end

  def per_year
    per_day_year * 365
  end

end