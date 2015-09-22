class AddDescriptionIdColumnToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :description_id, :string
  end
end
