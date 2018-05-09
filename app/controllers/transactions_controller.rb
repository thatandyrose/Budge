class TransactionsController < ApplicationController
  before_action :load_transaction, only: [:update, :apply_category_to_similar]

  def index
    params[:transaction_type] ||= 'expense'

    @pre_category_transactions = Transaction.filter(params.except(:category))
    @categories = @pre_category_transactions.pluck(:category).uniq.to_a.select(&:present?) + ['none']
    @transactions = Transaction.filter(params)
  end

  def apply_category_to_similar
    @transaction.apply_category_to_similar!
    @transactions = Transaction.filter(params)
  end

  def update    
    @transaction.update_attributes! strong_params
  end

  def import
    
    if params[:uri].present?
      type = params[:uri].include?('lloyds') ? :lloyds : :barclays
      Transaction.import type, params[:uri]
      redirect_to root_path
    end
    
  end

  private

  def load_transaction
    @transaction = Transaction.find params[:id]
  end

  def strong_params
    params.require(:transaction).permit :category
  end

end
