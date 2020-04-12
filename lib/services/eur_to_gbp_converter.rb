class EurToGbpConverter
  include HTTParty
  base_uri 'api.exchangeratesapi.io'

  def rate_for_date(date_string)
    query = {symbols: 'GBP'}
    h = JSON.parse self.class.get("/#{date_string}", {query: query}).body
    h['rates']['GBP']
  end

  def rates_for_range(start_date_string, end_date_string)
    query = {symbols: 'GBP', start_at: start_date_string, end_at: end_date_string}
    h = JSON.parse self.class.get("/history", {query: query}).body
    h['rates'].map{|k,v| {date: k, rate: v['GBP']}}.sort_by{|o| Date.parse o[:date] }
  end
end