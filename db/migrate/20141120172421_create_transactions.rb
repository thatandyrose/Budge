class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.date :date
      t.decimal :amount
      t.text :tags
      t.string :transaction_type
      t.text :description

      t.timestamps
    end
  end
end
