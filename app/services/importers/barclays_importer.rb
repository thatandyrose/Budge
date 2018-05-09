module Importers

  class BarclaysImporter < BaseImporter

    def self.sanitize(description)
      description.chars.select(&:valid_encoding?).join.encode('UTF-8')
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
      description.gsub(extract_date_str(description).to_s, '')
    end

    def self.extract_date(original_date, description)
      if d = extract_date_str(description)
        original_date = Date.parse(original_date)
        new_date = Date.parse "#{d} #{original_date.year}"

        if new_date > original_date
          new_date = Date.parse "#{d} #{(original_date - 1.month).year}"
        end

        new_date
      end
    end

    def self.extract_date_str(description)
      parts = trim(description).split " "
      on_index = parts.index 'ON'

      if on_index
        date_str = "#{parts[on_index]} #{parts[on_index + 1]} #{parts[on_index + 2]}"
        begin
          Date.parse date_str
          date_str
        rescue Exception => e
          nil
        end

      end

    end

    def import
      Transaction.transaction do

        CsvParser.new(@uri).iterate_csv do |row|
          is_income = row[:amount].to_d > 0

          memo = self.class.sanitize row[:memo]

          t = Transaction.new(
            date: self.class.extract_date(row[:date], memo) || Date.parse(row[:date]),
            amount: row[:amount].gsub(',','').to_d.abs,
            transaction_type: is_income ? 'income' : 'expense',
            raw_description: "#{row[:subcategory]}: #{self.class.trim(memo)}",
            description: self.class.trim(self.class.clean_raw_description(memo)),
            original_date: Date.parse(row[:date])
          )

          save_transaction!(t) if !t.has_dupe?

        end

      end

    end

  end

end
