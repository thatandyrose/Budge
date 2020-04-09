namespace :currency do
  task test: :environment do
    puts EurToGbpConverter.new.rate_for_date('2020-03-07')
  end
end
