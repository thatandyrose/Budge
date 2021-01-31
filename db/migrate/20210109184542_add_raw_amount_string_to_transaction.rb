class AddRawAmountStringToTransaction < ActiveRecord::Migration[5.2]
  def change
    add_column :transactions, :raw_amount_string, :string
  end
end
