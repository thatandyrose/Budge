class SpendCalculator
  def initialize(transcations)
    @transcations = transcations
  end

  def avg_spend_per_month
    months = amounts_per_month.to_a
    months.sum{|m|m.sum}/months.size
  end

  def amounts_per_month
    @transcations.select("date_trunc('month',date)::date as month, sum(amount)").group("month").order("month")
  end
end