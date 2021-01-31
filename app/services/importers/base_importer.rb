module Importers

  class BaseImporter

    def initialize(uri)
      @uri = uri
    end

    def save_transaction!(mapped_transaction)
      dupe = mapped_transaction.has_dupe?
      if !dupe
        mapped_transaction.update_description_id
        mapped_transaction.category = mapped_transaction.find_similar_to_me_with_trigger.try :category
        mapped_transaction.save!
      else
        dupe.update! raw_amount: mapped_transaction.raw_amount, raw_amount_string: mapped_transaction.raw_amount_string
      end
    end

  end

end