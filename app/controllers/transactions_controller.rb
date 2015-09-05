class TransactionsController < ApplicationController

  def index
    if params[:month]
      @transactions = Transaction.order_latest.for_month(params[:month])
    else
      @transactions = Transaction.order_latest
    end    
  end

  def update
    @transaction = Transaction.find params[:id]
    @transaction.update_attributes! strong_params
  end

  def import
    
    if params[:uri].present?
      Transaction.import :barclays, params[:uri]
      redirect_to root_path
    end
    
  end

  private

  def strong_params
    params.require(:transaction).permit :category
  end

end
