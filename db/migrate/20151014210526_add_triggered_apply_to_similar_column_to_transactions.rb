class AddTriggeredApplyToSimilarColumnToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :triggered_apply_to_similar, :date
  end
end
