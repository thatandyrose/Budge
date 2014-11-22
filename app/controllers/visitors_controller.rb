class VisitorsController < ApplicationController

  def index
    @this_month = ExpensesCalculator.new(Time.now)
    @last_month = ExpensesCalculator.new(Time.now - 1.month)
  end
end
