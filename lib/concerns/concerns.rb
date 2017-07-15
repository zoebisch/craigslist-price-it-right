
module Concerns

  module Searchable
    @search_list = []

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

  module Printable

    def print_items
      #ist.each_with_index{|obj,ind| yield(obj,ind)}
      binding.pry
      @search_list.each_with_index{|item,ind| puts ind + ". " + item}
    end

  end

  module Statistical
    @@basic_stats = {}

    def basic_stats
      values = items_with_price.collect{|item| item.price}
      @@basic_stats[:volume] = values.count
      @@basic_stats[:mean] = values.reduce(:+)/@@basic_stats[:volume]
      @@basic_stats[:min] = values.min
      @@basic_stats[:max] = values.max
      @@basic_stats
    end
  end

end
