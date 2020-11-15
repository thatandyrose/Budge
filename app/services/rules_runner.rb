class RulesRunner
  def initialize(transaction)
    @transaction = transaction
  end

  def call
    if @transaction.amount && @transaction.category.blank?
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

      apply_rule "WITHDRAWAL", 'cash', { source: 'sabadell', max_amount: 600 }

      apply_rule "farmacia", 'doctors/medicine/health'

      apply_rule "Chiropractic", 'doctors/medicine/health'

      apply_rule "costaspine", 'doctors/medicine/health'

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

      apply_rule "three", 'utilities/telecomms', {source: 'revolut'}

      apply_rule "AWS", 'utilities/telecomms'

      apply_rule "taxi", 'taxi'

      apply_rule "uber", 'taxi'

      apply_rule "Gpv Benahavis FX Rate", 'groceries'

      apply_rule "Da Bruno a San Pedro FX Rate", "food and drink"

      apply_rule "Organic With Love", "food and drink", {source: 'revolut'}

      apply_rule "Organic With Love", "groceries", {source: 'sabadell'}

      apply_rule "AUTOPISTA DEL SOL", "parking"

      apply_rule "Audible Ltd", "utilities/telecomms"

      apply_rule "OLIVENET", "utilities/telecomms"

      apply_rule "RENTING BANSABADELL", "car", {source: 'sabadell', max_amount: 600}

      apply_rule "ZARA", 'shopping'

      apply_rule "Urban Bistro", 'food and drink'

      apply_rule "Yogazone", 'fitness/gym/yoga'

      apply_rule "Restaurante La Ruta", 'food and drink'

      apply_rule "GUARDIAN NEWS", 'entertainment/events/culture'

      apply_rule "MINI INDIA", 'food and drink'

      apply_rule "Audible UK", 'entertainment/events/culture'

      apply_rule "ANDREW ROSE TOP UP", 'internal transfer', {source: 'barclays', max_amount: 900}

      apply_rule "REVOLUT", 'internal transfer', {source: 'barclays', max_amount: 1000}

      apply_rule "204980 13143252", 'internal transfer', {source: 'barclays', max_amount: 6000}

      apply_rule "viva aqua", 'groceries'

      apply_rule "experian", 'utilities/telecomms'

      apply_rule "GOOGLE *Google Pla", 'utilities/telecomms', { max_amount: 10 }

      apply_rule "GUARDIAN MEDIA", 'entertainment/events/culture'

      apply_rule "HOVER USA", 'utilities/telecomms'

      apply_rule "GLO COM-SANTA MONICA", 'fitness/gym/yoga'

      apply_rule "sanebox Inc", 'utilities/telecomms'

      apply_rule "IAN HANCOCK", 'rent', {source: 'lloyds', max_amount: 1600, min_amount: 1400}

      apply_rule "CHIRINGUITO", 'food and drink', {source: 'lloyds', max_amount: 40}

      apply_rule "CHIRINGUITO", 'food and drink', {source: 'barclays', max_amount: 40}

      apply_rule "CHIRINGUITO", 'shopping', {source: 'sabadell', max_amount: 100}

      apply_rule "COMISSIONS/FEES", 'life admin', {source: 'sabadell', max_amount: 3}

      apply_rule "GPV BENAHAVIS SPAIN", 'groceries', {max_amount: 50}

      apply_rule "[Restaurants]", 'shopping', {source: 'sabadell'}

      apply_rule "[Restaurants]", 'shopping', {source: 'revolut', min_amount: 39.99}

      apply_rule "[Restaurants]", 'shopping', {source: 'barclays', min_amount: 39.99}

      apply_rule "[Restaurants]", 'food and drink', {source: 'revolut', max_amount: 40}

      apply_rule "[Restaurants]", 'food and drink', {source: 'barclays', max_amount: 40}
    end
  end

  def apply_rule(match, cat, options = {})
    if options[:source]
      source_condition =  @transaction.source == options[:source]
    else
      source_condition = true
    end

    if options[:max_amount]
      max_amount_condition = @transaction.amount < options[:max_amount]
    else
      max_amount_condition = @transaction.amount < 200
    end

    if options[:min_amount]
      min_amount_condition = @transaction.amount > options[:min_amount]
    else
      min_amount_condition = @transaction.amount > 0
    end

    if  @transaction.description.downcase.include?(match.downcase) && source_condition && max_amount_condition && min_amount_condition && @transaction.category.blank?
      @transaction.category = cat
    end
  end
end