class Transaction < ActiveRecord::Base
  serialize :tags

  default_scope { order(date: :asc) }
  scope :expenses, ->{ where(transaction_type:'expense') }
  scope :incomes, ->{ where(transaction_type:'income') }

  def self.import(format, uri)
    "Importers::#{format.to_s.titleize}Importer".constantize.new(uri).import
  end

  def self.for_tag(tag)
    
    if tag
      where("tags like ?", "%#{tag}%")
    else
      where('true = true')
    end

  end

end
