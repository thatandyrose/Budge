module Importers

  class BarclaysImporter

    def initialize(uri)
      @uri = uri
    end

    def self.clean_raw_description(description)
      to_remove = ['CLP', 'BCC', 'BGC']
      
      to_remove.each do |tr|
        description = description.gsub(tr, '')
      end

      remove_date(description)

    end

    def self.trim(str)
      str.split(" ").select(&:present?).join(" ")
    end

    def self.remove_date(description)
      parts = description.split " "
      
      on_index = parts.index 'ON'

      if on_index
        parts.delete_at on_index + 1
        parts.delete_at on_index + 1
        parts.delete_at on_index

        parts.join " "
      else
        description
      end
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
            raw_description: "#{row[:subcategory]}: #{BarclaysImporter.trim(row[:memo])}".encode('UTF-8'),
            description: BarclaysImporter.trim(BarclaysImporter.clean_raw_description(row[:memo]))
          )

          t.save! if is_new(t)
        end

      end

    end

  end

end