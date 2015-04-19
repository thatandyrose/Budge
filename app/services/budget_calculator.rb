class BudgetCalculator

  def transactions
    @transactions ||= Transaction.incomes
  end

  def total_income
    @total_income ||= transactions.pluck(:amount).sum
  end

  def per_day_ahead
    
    @per_day_ahead ||= begin
      if transactions.any?
        days = transactions.last.date - transactions.first.date
        total_income/(days + 30)
      else
        0
      end
    end

  end

  def per_day_average

    @per_day_average ||= begin
      days = Transaction.last.date - Transaction.first.date
      total_income/days
    end

  end
end