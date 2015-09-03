class TransactionsController < ApplicationController

  def import
    
    if params[:uri].present?
      Transaction.import :barclays, params[:uri]
      redirect_to root_path
    end
    
  end

end
