class AddOriginalDateColumnToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :original_date, :date
  end
end
