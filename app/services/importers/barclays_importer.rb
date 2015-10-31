module Importers

  class BarclaysImporter < BaseImporter

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
      description.gsub(extract_date_str(description).to_s, '')
    end

    def self.extract_date(description)
      if d = extract_date_str(description)
        Date.parse d
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
          
          t = Transaction.new(
            date: Date.parse(row[:date]),
            amount: row[:amount].gsub(',','').to_d.abs,
            transaction_type: is_income ? 'income' : 'expense',
            raw_description: "#{row[:subcategory]}: #{BarclaysImporter.trim(row[:memo])}".encode('UTF-8'),
            description: BarclaysImporter.trim(BarclaysImporter.clean_raw_description(row[:memo]))
          )

          save_transaction!(t) if !t.has_dupe?
        end

      end

    end

  end

end