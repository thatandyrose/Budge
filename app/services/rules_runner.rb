class RulesRunner
  def initialize(transaction)
    @transaction = transaction
  end

  def call
    if @transaction.amount && @transaction.category.blank? && @transaction.amount < 200
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

      apply_rule "SUPERMERCADO", 'groceries'

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

      apply_rule "AUTOPISTA DEL SOL", "parking"

      apply_rule "Audible Ltd", "utilities/telecomms"

      apply_rule "OLIVENET", "utilities/telecomms"

      apply_rule "RENTING BANSABADELL", "car"

      apply_rule "ZARA", 'shopping'

      apply_rule "Urban Bistro", 'food and drink'

      apply_rule "Yogazone", 'fitness/gym/yoga'

      apply_rule "Restaurante La Ruta", 'food and drink'

      apply_rule "GUARDIAN NEWS", 'entertainment/events/culture'

      apply_rule "MINI INDIA", 'food and drink'

      apply_rule "Audible UK", 'entertainment/events/culture'

      apply_rule "ANDREW ROSE TOP UP", 'internal transfer'

      apply_rule "REVOLUT", 'internal transfer', 'barclays'

      apply_rule "viva aqua", 'groceries'

      apply_rule "experian", 'utilities/telecomms'

      apply_rule "GUARDIAN MEDIA", 'entertainment/events/culture'
    end
  end

  def apply_rule(match, cat, _source = nil)
    if _source
      source_condition =  @transaction.source == _source
    else
      source_condition = true
    end

    if  @transaction.description.downcase.include?(match.downcase) && source_condition
      @transaction.category = cat
    end
  end
end