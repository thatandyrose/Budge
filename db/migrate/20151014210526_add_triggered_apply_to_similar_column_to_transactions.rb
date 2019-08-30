class AddTriggeredApplyToSimilarColumnToTransactions < ActiveRecord::Migration[4.2]
  def change
    add_column :transactions, :triggered_apply_to_similar, :date
  end
end
