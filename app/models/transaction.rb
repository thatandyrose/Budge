class Transaction < ActiveRecord::Base
  serialize :tags

  default_scope { order(date: :asc) }
  scope :expenses, ->{ where(transaction_type:'expense') }

  def self.import(uri)
    
    Transaction.transaction do
      destroy_all

      CsvParser.new(uri).iterate_csv do |row|
        is_income = row[:income_amount].present?
        create!(
          date: Date.parse(row[:date]),
          amount: is_income ? row[:income_amount].to_d : row[:expense_amount].to_d,
          transaction_type: is_income ? 'income' : 'expense',
          description: row[:description],
          tags: row[:entry_tags].split(',').map(&:strip)
        )
      end

    end

  end
end
