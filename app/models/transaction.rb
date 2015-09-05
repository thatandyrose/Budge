class Transaction < ActiveRecord::Base
  serialize :tags

  scope :order_latest, ->{ order(date: :desc) }
  scope :expenses, ->{ where(transaction_type:'expense') }
  scope :incomes, ->{ where(transaction_type:'income') }
  
  scope :for_month, ->(date){
    d = Date.parse(date)
    where(date: [d.beginning_of_month..d.end_of_month])
  }

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
