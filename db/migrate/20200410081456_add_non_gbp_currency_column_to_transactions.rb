class AddNonGbpCurrencyColumnToTransactions < ActiveRecord::Migration[5.2]
  def change
    add_column :transactions, :non_gbp_currency, :string
  end
end
