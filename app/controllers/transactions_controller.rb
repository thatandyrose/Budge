class TransactionsController < ApplicationController

  def index
    if params[:month]
      @transactions = Transaction.order_latest.for_month(params[:month])
    else
      @transactions = Transaction.order_latest
    end    
  end

  def import
    
    if params[:uri].present?
      Transaction.import :barclays, params[:uri]
      redirect_to root_path
    end
    
  end

end
