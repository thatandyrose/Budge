namespace :currency do
  task convert: :environment do
    ConvertRequiredCurrencies.new.call
  end
end
