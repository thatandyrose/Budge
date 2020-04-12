class AddAmountNonGbpColumnToTransactions < ActiveRecord::Migration[5.2]
  def change
    add_column :transactions, :amount_non_gbp, :decimal
  end
end
