class TransactionsController < ApplicationController
  before_action :load_transaction, only: [:update, :apply_category_to_similar]

  def index

    respond_to do |format|
      format.html
      format.json { 
        pre_category_transactions = Transaction.filter(params.except(:category))
        @categories = (pre_category_transactions
          .pluck(:category)
          .uniq.to_a
          .select(&:present?) + ['none'])
          .map do |category|
            {
              name: category,
              amount: pre_category_transactions.for_category(category).pluck(:amount).sum
            }
          end
        @transactions = Transaction.filter(params)
      }
    end

  end

  def apply_category_to_similar
    @transaction.apply_category_to_similar!
    @transactions = Transaction.filter(params)
    render json: {success: true}
  end

  def run_rules
    Transaction.run_rules
    @transactions = Transaction.filter(params)
    render json: {success: true}
  end

  def update
    @transaction.update_attributes! strong_params
    render json: {success: true}
  end

  def import
    if params[:uri].present?
      Transaction.import params[:bank], params[:uri]
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
