class AddCategoryAndRawDescriptionColumnToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :category, :string
    add_column :transactions, :raw_description, :text
  end
end
