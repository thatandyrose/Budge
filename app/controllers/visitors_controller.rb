class VisitorsController < ApplicationController

  def index
    @start_date = (params[:start_date] && Date.parse(params[:start_date])) || Transaction.order(date: :asc).first.date.beginning_of_month 
    @end_date = params[:end_date] && Date.parse(params[:end_date]) || (Time.now - 1.month).beginning_of_month.to_date

    transactions = Transaction.spending_expenses.where(date: [@start_date..@end_date])

    @calculator = SpendCalculator.new(transactions)
  end
end
