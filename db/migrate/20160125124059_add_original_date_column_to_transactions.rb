class AddOriginalDateColumnToTransactions < ActiveRecord::Migration[4.2]
  def change
    add_column :transactions, :original_date, :date
  end
end
