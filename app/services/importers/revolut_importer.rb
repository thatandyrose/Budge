module Importers

  class RevolutImporter < BaseImporter

    def import
      Transaction.transaction do

        CsvParser.new(@uri, col_sep: ';').iterate_csv do |row|
          is_income = row[:paid_in_gbp].present? && row[:paid_in_gbp].to_d > 0

          description = row[:description].to_s.encode('UTF-8', invalid: :replace, undef: :replace)

          t = Transaction.new(
            date: Date.parse(row[:completed_date]),
            amount: (row[:paid_out_gbp].presence || row[:paid_in_gbp].presence).to_d,
            transaction_type: is_income ? 'income' : 'expense',
            raw_description: "[#{row[:category]}] #{description}",
            description: "[#{row[:category]}] #{description}",
            original_date: Date.parse(row[:completed_date]),
            source: 'revolut'
          )

          save_transaction!(t) if !t.has_dupe?

        end

      end

    end

  end

end
