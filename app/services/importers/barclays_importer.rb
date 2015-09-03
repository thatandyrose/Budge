module Importers

  class BarclaysImporter

    def initialize(uri)
      @uri = uri
    end

    def is_new(transaction)
      !Transaction.where(date: transaction.date, amount: transaction.amount, transaction_type: transaction.transaction_type, description: transaction.description).any?
    end

    def import

      Transaction.transaction do

        CsvParser.new(@uri).iterate_csv do |row|
          is_income = row[:amount].to_d > 0
          
          t = Transaction.new(
            date: Date.parse(row[:date]),
            amount: row[:amount].gsub(',','').to_d.abs,
            transaction_type: is_income ? 'income' : 'expense',
            description: "#{row[:subcategory]}: #{row[:memo].split(" ").select(&:present?).join(" ")}"
          )

          t.save! if is_new(t)
        end

      end

    end

  end

end