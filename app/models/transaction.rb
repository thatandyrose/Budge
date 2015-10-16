class Transaction < ActiveRecord::Base
  serialize :tags

  scope :order_latest, ->{ order(date: :desc, created_at: :asc) }
  scope :expenses, ->{ where(transaction_type:'expense') }
  scope :incomes, ->{ where(transaction_type:'income') }
  scope :similar, ->(description_id){ where(description_id: description_id) }
  
  scope :for_month, ->(date){
    d = Date.parse(date)
    where(date: [d.beginning_of_month..d.end_of_month])
  }

  scope :for_category, ->(category){
    where(category: category)
  }

  before_save :update_description_id

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

  def self.filter(params)
    query = order_latest

    if params[:month].present?
      query = query.for_month(params[:month])
    end

    if params[:transaction_type].present?
      query = query.where(transaction_type: params[:transaction_type])
    end

    if params[:category].present?
      query = query.where(category: params[:category])
    end
    
    query
  end

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

  def find_similar_to_me_with_trigger
    similar_to_me
      .where("triggered_apply_to_similar is not null")
      .first
  end

  def similar_to_me
    Transaction.similar(description_id).where('id <> ?', self.id || 0)
  end

  def apply_category_to_similar!
    
    if description.present? && description_id.present?
      
      Transaction.transaction do
        similar_to_me
          .where("category is null OR category = ''")
          .update_all category: category
        
        self.update_attributes! triggered_apply_to_similar: Date.today
      end
      
    end

  end

  def update_description_id
    self.description_id = description.urlify
  end

end
