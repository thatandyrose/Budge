class AddRawAmountToTransaction < ActiveRecord::Migration[5.2]
  def change
    add_column :transactions, :raw_amount, :decimal
  end
end
