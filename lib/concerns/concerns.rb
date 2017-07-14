
module Concerns

  module Searchable
    @search_list = []
    @price_list = []

    def search_by_type(search_item)
      #Extend this to check any of the item's scraped attributes
      @search_list = self.all.select{|item| item if item.title.include?(" " + search_item + " ")} #Spaces to help search scope
    end

    def items_with_price
      @search_list.select{|item| item if item.price != nil}
    end

    def get_link_from_key
      CL_Scraper.menu_hash.fetch(self.category) #TODO: add check to prevent user input misspellings, etc
    end

  end

  module Sortable

    def sort_by_price
      items_with_price.sort{|a,b| a.price <=> b.price}
    end

  end

  module Statistical
    attr_accessor :volume, :mean, :low, :high

    def basic_stats
      values = items_with_price.collect{|item| item.price}
      @volume = values.count
      @mean = values.reduce(:+)/@volume
      @low = values.min
      @high = values.max
    end
  end

end
