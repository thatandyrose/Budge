class Transaction < ActiveRecord::Base
  serialize :tags

  scope :order_latest, ->{ order(date: :desc, created_at: :asc) }
  scope :expenses, ->{ where(transaction_type:'expense') }
  scope :incomes, ->{ where(transaction_type:'income') }
  
  scope :for_month, ->(date){
    d = Date.parse(date)
    where(date: [d.beginning_of_month..d.end_of_month])
  }

  CATEGORIES = [
    'utilities/telecomms',
    'entertainment/events/culture',
    'haircut',
    'fix/replace',
    'trip trasnport',
    'gift',
    'public transport',
    'house stuff',
    'education',
    'fitness/gym/yoga',
    'food and drink',
    'life admin',
    'trip money',
    'doctors/medicine/health',
    'btmetrics',
    'taxi',
    'shopping',
    'groceries',
    'rent'
  ]

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
