require 'csv'
require 'open-uri'

class CsvParser
  
  def initialize(file_uri)
    @file_uri = file_uri
  end

  def file
    @file ||= open(@file_uri, "r:ISO-8859-1")
  end

  def iterate_csv(&block)
    row_count = 0
    header = nil
    file.each_line do |line|
      row = sanitize_csv_row_values parse_line(line)

      if row_count > 0 #we don't want to import the header row.
        block.call(create_row_hash(header,row))
      else
        header = row
      end

      row_count += 1
    end
  end

  private

  def parse_line(line)
    #http://stackoverflow.com/a/19042554
    quote_chars = %w(" | ~ ^ & *)

    begin
      line = line.parse_csv quote_char: quote_chars.shift
    rescue CSV::MalformedCSVError
      quote_chars.empty? ? raise : retry 
    end

    line
  end

  def create_row_hash(header_array, values_array)
    new_hash = {}
    
    header_array.each_with_index do |key, i|
      #remove weird char from beginning
      if !key[0].match(/^[a-zA-Z0-9_-]+$/)
        key.slice!(0)
      end
      new_hash = new_hash.merge(key.urlify.gsub('-', '_').to_sym => values_array[i])
    end

    new_hash
  end

  def sanitize_csv_row_values(row_array)
    row_array.map{|val|val.to_s.strip}
  end
end