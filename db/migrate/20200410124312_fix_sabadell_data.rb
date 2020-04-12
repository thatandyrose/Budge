class FixSabadellData < ActiveRecord::Migration[5.2]
  def up
    Transaction
      .where(source: 'sabadell')
      .find_each do |t|
        t.amount_non_gbp = t.amount
        t.amount = nil
        t.non_gbp_currency = 'EUR'
        t.save!
      end
  end
end
