class ExpensesCalculator

  def initialize(month_as_date)
    @month = month_as_date.to_date
  end

  def transactions
    @transactions ||= Transaction.expenses
      .where(date: @month.beginning_of_month..@month.end_of_month)
  end

  def per_day
    total_spent / month_length
  end

  def total_spent
    @total_spent ||= transactions.pluck(:amount).sum
  end

  def month_length

    @month_length ||= case @month.beginning_of_month
    
    when Transaction.first.date.beginning_of_month
      #its the first month of usage
      @month.end_of_month.day - transactions.first.date.day
    when Time.now.beginning_of_month
      #its the current month
      transactions.last.date.day
    else
      @month.end_of_month.day
    end

  end

  def last_month_expenses
    @last_month_expenses ||= ExpensesCalculator.new(@month - 1.month)
  end

  def daily_budget_to_match_last_month
    days_left_this_month = @month.end_of_month.day - transactions.last.date.day
    total_budget_to_match_last_month/days_left_this_month
  end

  def total_budget_to_match_last_month
    last_month_expenses.total_spent - total_spent
  end

end