class BudgetCalculator

  def transactions
    @transactions ||= Transaction.incomes
  end

  def total_income
    @total_income ||= transactions.pluck(:amount).sum
  end

  def per_day_ahead
    
    @per_day_ahead ||= begin
      days = transactions.last.date - transactions.first.date
      total_income/(days + 30)
    end

  end
end