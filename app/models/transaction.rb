class Transaction < ActiveRecord::Base
  serialize :tags

  scope :order_latest, ->{ order(date: :desc, created_at: :asc) }
  scope :expenses, ->{ where(transaction_type:'expense') }
  scope :incomes, ->{ where(transaction_type:'income') }
  scope :similar, ->(description_id){ where(description_id: description_id) }

  scope :for_month, ->(date_str){
    d = Date.parse(date_str)
    where(date: [d.beginning_of_month..d.end_of_month])
  }

  scope :for_category, ->(category){
    if category == 'none'
      where(category: nil)
    else
      where(category: category)
    end

  }

  scope :spending_expenses, ->{ expenses.where("category <> ?", 'internal transfer') }

  before_save :update_description_id, :run_rules

  CATEGORIES = [
    'utilities/telecomms',
    'computer hardware',
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
    'rent',
    'internal transfer',
    'current account transfer',
    'tax',
    'company admin',
    'parking',
    'car insurance',
    'car',
    '** suspicious/unknown',
    'cash'
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
      query = query.for_category params[:category]
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

  def self.run_rules
    Transaction
      .where(category: nil)
      .where("amount < 200")
      .find_each(batch_size: 500) do |t|
        t.run_rules
        t.save!
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
          .update_all category: category, triggered_apply_to_similar: Date.today

        self.update_attributes! triggered_apply_to_similar: Date.today
      end

    end

  end

  def has_dupe?
    Transaction.where(date: date, amount: amount, transaction_type: transaction_type, description: description).where.not(id: id).any?
  end

  def update_description_id
    self.description_id = description.urlify
  end

  def apply_rule(match, cat, _source = nil)
    if _source
      source_condition = self.source == _source
    else
      source_condition = true
    end

    if description.downcase.include?(match.downcase) && source_condition
      self.category = cat
    end
  end
  
  def run_rules
    if category.blank? && amount < 200
      apply_rule "Amazon.co.uk", 'shopping'

      apply_rule "AMAZON.ES", 'shopping'

      apply_rule "EL CORTE INGLES", 'shopping'

      apply_rule "amazon fx rate", 'shopping'

      apply_rule "amazon.es-amazon.es", 'shopping'
      
      apply_rule "mundo mania", 'entertainment/events/culture'
      apply_rule "Mundo ManÃ­a FX", 'entertainment/events/culture'
      apply_rule "netflix", 'entertainment/events/culture'

      apply_rule "gym junkie fx rate", 'food and drink'

      apply_rule "Organic Cold Pressed Juicery FX Rate", 'food and drink'

      apply_rule "Reebok Hybrid FX Rate", 'fitness/gym/yoga'

      apply_rule "Firstedition Sl FX Rate", 'food and drink'

      apply_rule "spotify", 'utilities/telecomms'

      apply_rule "WITHDRAWAL", 'cash'

      apply_rule "farmacia", 'doctors/medicine/health'

      apply_rule "aldi", 'groceries'

      apply_rule "SUPERSOL", 'groceries'

      apply_rule "Mercadona", 'groceries'

      apply_rule "LIDL", 'groceries'

      apply_rule "MINIMARKET", 'groceries'

      apply_rule "CARNICERIA", 'groceries'

      apply_rule "Fruteria", 'groceries'

      apply_rule "Maskom", 'groceries'

      apply_rule "Supercor", 'groceries'

      apply_rule "AMZN Mktp", 'shopping'

      apply_rule "EE BROADBAND", 'utilities/telecomms'

      apply_rule "HEROKU", 'utilities/telecomms'

      apply_rule "THREE.CO.UK", 'utilities/telecomms'

      apply_rule "three", 'utilities/telecomms', 'revolut'

      apply_rule "AWS", 'utilities/telecomms'

      apply_rule "taxi", 'taxi'

      apply_rule "uber", 'taxi'

      apply_rule "Gpv Benahavis FX Rate", 'groceries'

      apply_rule "Da Bruno a San Pedro FX Rate", "food and drink"

      apply_rule "Organic With Love", "food and drink", 'revolut'

      apply_rule "Organic With Love", "groceries", 'sabadell'

      apply_rule "AUTOPISTA DEL SOL SPAIN", "car"

      apply_rule "Audible Ltd", "utilities/telecomms"
    end
  end

end
