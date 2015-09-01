class ExpensesCalculator

  def initialize(month_as_date, tag = nil)
    @month = month_as_date.to_date
    @tag = tag
  end

  def month
    @month
  end

  def tag
    @tag
  end

  def transactions
    @transactions ||= Transaction.expenses
      .where(date: month.beginning_of_month..month.end_of_month)
  end

  def tagged_transactions
    @tagged_transactions ||= transactions.for_tag(@tag)
  end

  def per_day
    total_spent / month_length
  end

  def total_spent
    @total_spent ||= tagged_transactions.pluck(:amount).sum
  end

  def month_length

    @month_length ||= begin

      case month.beginning_of_month
      
      when Transaction.first && Transaction.first.date.beginning_of_month
        #its the first month of usage
        month.end_of_month.day - transactions.first.date.day
      when Time.now.beginning_of_month
        #its the current month
        transactions.last.date.day
      else
        month.end_of_month.day
      end
    end

  end

  def last_month_expenses
    @last_month_expenses ||= ExpensesCalculator.new(month - 1.month, @tag)
  end

  def daily_budget_to_match_last_month
    days_left_this_month = month.end_of_month.day - transactions.last.date.day
    total_budget_to_match_last_month/days_left_this_month
  end

  def total_budget_to_match_last_month
    last_month_expenses.total_spent - total_spent
  end

  def for_tags
    
    if !@tag
      @for_tags ||= Transaction.pluck(:tags).flatten.uniq.map { |tag|
        {
          tag: tag,
          expenses: ExpensesCalculator.new(month, tag)
        }
      }.sort_by{|tex| tex[:expenses].total_spent}.reverse
    end

  end

end