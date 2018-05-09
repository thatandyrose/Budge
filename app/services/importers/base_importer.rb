module Importers

  class BaseImporter

    def initialize(uri)
      @uri = uri
    end

    def save_transaction!(mapped_transaction)
      mapped_transaction.update_description_id
      mapped_transaction.category = mapped_transaction.find_similar_to_me_with_trigger.try :category
      mapped_transaction.save!
    end

  end

end