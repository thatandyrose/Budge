class AddDescriptionIdColumnToTransactions < ActiveRecord::Migration[4.2]
  def change
    add_column :transactions, :description_id, :string
  end
end
