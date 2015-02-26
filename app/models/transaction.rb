class Transaction < ActiveRecord::Base
  serialize :tags

  default_scope { order(date: :asc) }
  scope :expenses, ->{ where(transaction_type:'expense') }
  scope :incomes, ->{ where(transaction_type:'income') }

  def self.import(uri)
    
    Transaction.transaction do
      destroy_all

      CsvParser.new(uri).iterate_csv do |row|
        is_income = row[:income_amount].present?
        
        create!(
          date: Date.parse(row[:date]),
          amount: (is_income ? row[:income_amount] : row[:expense_amount]).gsub(',','').to_d,
          transaction_type: is_income ? 'income' : 'expense',
          description: row[:description],
          tags: row[:entry_tags].split(',').map(&:strip)
        )
      end

    end

  end

  def self.for_tag(tag)
    
    if tag
      where("tags like ?", "%#{tag}%")
    else
      where('true = true')
    end

  end

end
