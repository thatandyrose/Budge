class VisitorsController < ApplicationController

  def index
    @this_month = ExpensesCalculator.new(Time.now)
    @last_month = ExpensesCalculator.new(Time.now - 1.month)
    @actual_budget = BudgetCalculator.new
  end
end
