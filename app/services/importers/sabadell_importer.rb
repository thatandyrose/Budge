module Importers

  class SabadellImporter < BaseImporter

    def import
      Transaction.transaction do
        ::CsvParser.new(@uri, col_sep: ';').iterate_csv do |row|
          is_income = row[:amount].to_d > 0

          description = row[:item].to_s.encode('UTF-8', invalid: :replace, undef: :replace)

          t = Transaction.new(
            date: Date.parse(row[:operation_date]),
            amount: row[:amount].to_d,
            transaction_type: is_income ? 'income' : 'expense',
            raw_description: description,
            description: description,
            original_date: Date.parse(row[:operation_date]),
            source: 'sabadell'
          )

          save_transaction!(t) if !t.has_dupe?

        end

      end

    end

  end

end
