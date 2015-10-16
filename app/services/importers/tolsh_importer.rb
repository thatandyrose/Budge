module Importers

  class TolshImporter < BaseImporter

    def initialize(uri)
      @uri = uri
    end

    def import

      Transaction.transaction do
        Transaction.destroy_all

        CsvParser.new(@uri).iterate_csv do |row|
          is_income = row[:income_amount].present?
          
          t = Transaction.new(
            date: Date.parse(row[:date]),
            amount: (is_income ? row[:income_amount] : row[:expense_amount]).gsub(',','').to_d,
            transaction_type: is_income ? 'income' : 'expense',
            description: row[:description],
            tags: row[:entry_tags].split(',').map(&:strip)
          )

          save_transaction!(t)
        end

      end

    end

  end

end