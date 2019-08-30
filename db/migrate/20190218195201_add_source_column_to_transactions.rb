class AddSourceColumnToTransactions < ActiveRecord::Migration[4.2]
  def change
    add_column :transactions, :source, :string
  end
end
