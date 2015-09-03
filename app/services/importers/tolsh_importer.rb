module Importers

  class TolshImporter

    def initialize(uri)
      @uri = uri
    end

    def import

      Transaction.transaction do
        Transaction.destroy_all

        CsvParser.new(@uri).iterate_csv do |row|
          is_income = row[:income_amount].present?
          
          Transaction.create!(
            date: Date.parse(row[:date]),
            amount: (is_income ? row[:income_amount] : row[:expense_amount]).gsub(',','').to_d,
            transaction_type: is_income ? 'income' : 'expense',
            description: row[:description],
            tags: row[:entry_tags].split(',').map(&:strip)
          )
        end

      end

    end

  end

end