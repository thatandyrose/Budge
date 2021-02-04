module Importers

  class SabadellImporter < BaseImporter

    def import
      Transaction.transaction do
        ::CsvParser.new(@uri, col_sep: ';').iterate_csv do |row|
          is_income = row[:amount].to_d > 0

          description = row[:item].to_s.encode('UTF-8', invalid: :replace, undef: :replace)

          t = Transaction.new(
            date: Date.parse(row[:operation_date]),
            amount_non_gbp: row[:amount].gsub(',','').to_d.abs,
            non_gbp_currency: 'EUR',
            transaction_type: is_income ? 'income' : 'expense',
            raw_description: description,
            description: description,
            original_date: Date.parse(row[:operation_date]),
            source: 'sabadell',
            raw_amount: row[:amount].gsub(',','').to_d.abs,
            raw_amount_string: row[:amount]
          )

          save_transaction!(t)

        end

      end

    end

  end

end
