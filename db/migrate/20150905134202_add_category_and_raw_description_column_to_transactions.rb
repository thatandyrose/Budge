class AddCategoryAndRawDescriptionColumnToTransactions < ActiveRecord::Migration[4.2]
  def change
    add_column :transactions, :category, :string
    add_column :transactions, :raw_description, :text
  end
end
