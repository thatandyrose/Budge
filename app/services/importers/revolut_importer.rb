module Importers

  class RevolutImporter < BaseImporter

    def import
      Transaction.transaction do

        CsvParser.new(@uri, col_sep: ';').iterate_csv do |row|
          is_income = row[:paid_in_gbp].present? && row[:paid_in_gbp].to_d > 0

          description = row[:description].to_s.encode('UTF-8', invalid: :replace, undef: :replace)

          amount = row[:paid_out_gbp].presence || row[:paid_in_gbp].presence

          t = Transaction.new(
            date: Date.parse(row[:completed_date]),
            amount: amount.gsub(',','').to_d.abs,
            transaction_type: is_income ? 'income' : 'expense',
            raw_description: "[#{row[:category]}] #{description}",
            description: "[#{row[:category]}] #{description}",
            original_date: Date.parse(row[:completed_date]),
            source: 'revolut',
            raw_amount: amount.gsub(',','').to_d.abs,
            raw_amount_string: amount
          )

          save_transaction!(t)

        end

      end

    end

  end

end
