module Importers

  class LloydsImporter < BaseImporter

    def import
      Transaction.transaction do

        CsvParser.new(@uri).iterate_csv do |row|
          is_income = row[:credit_amount].present? && row[:credit_amount].to_d > 0

          t = Transaction.new(
            date: Date.parse(row[:transaction_date]),
            amount: (row[:debit_amount].presence || row[:credit_amount].presence).to_d,
            transaction_type: is_income ? 'income' : 'expense',
            raw_description: row[:transaction_description],
            description: row[:transaction_description],
            original_date: Date.parse(row[:transaction_date]),
            source: 'lloyds'
          )

          save_transaction!(t) if !t.has_dupe?

        end

      end

    end

  end

end
