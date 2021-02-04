namespace :import do

  def amount_wrong
    Transaction
      .where.not(amount_non_gbp: nil)
      .where("amount_non_gbp <> raw_amount")
      .or(
        Transaction
          .where(amount_non_gbp: nil)
          .where("amount <> raw_amount")
      )
  end

  task :fix => [:environment] do
    amount_wrong.each do |t|
      if t.amount_non_gbp
        t.amount_non_gbp = t.raw_amount
        t.amount = nil
        t.save!
      else
        t.amount = t.raw_amount
        t.save!
      end
    end

    ConvertRequiredCurrencies.new.call
  end

  task :report => [:environment] do
    amount_wrong.each do |t|
      puts "date: #{t.date}, description: #{t.description}, amount: #{t.amount_non_gbp || t.amount}, raw: #{t.raw_amount}, source: #{t.source}, type: #{t.transaction_type}"
    end
  end

  task :batch => [:environment] do
    path = Rails.root.join('lib', 'tasks', 'statements', '*.csv')
    files = Dir.glob path

    files.map{|f|f.downcase}.each do |f|
      if f.include?('barclays') || f.include?('barclys')
        bank = 'barclays'
      end

      if f.include?('lloyds') || f.include?('loyds')
        bank = 'lloyds'
      end

      if f.include? 'revolut'
        bank = 'revolut'
      end

      if f.include? 'sabadell'
        bank = 'sabadell'
      end

      invalid_banks = []

      if bank
        Transaction.import bank, f
      else
       invalid_banks.push bank, file
      end

      if invalid_banks.any?
        puts "=========================="
        puts "Invalid banks:"
        invalid_banks.each do |invalid|
          puts invalid
        end
      end
    end
  end
end
