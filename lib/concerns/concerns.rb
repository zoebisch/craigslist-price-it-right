
module Concerns

  module Searchable
    @search_list = []
    @price_list = []

    def search_by_type(search_item = PriceManager.item) #Default search using class attribute, allows flexible searches
      #Extend this to check any Item class attribute
      @search_list = self.all.select{|item| item if item.title.include?(" " + search_item + " ")} #Spaces to help search scope
    end

    def items_with_price
      @search_list.select{|item| item if item.price != nil}
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
