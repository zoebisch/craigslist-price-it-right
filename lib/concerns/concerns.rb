require 'pry'
module Concerns

  module Searchable
    attr_accessor :site
    @search_list = []

    def search_by_type
      #Extend this to check any of the item's scraped attributes
      @site.all.select{|item| item if item[:title].include?(self.item)}
    end

    def search_by_pid(pid)
      pid_link = ""
      @items.select{|item| pid_link = item[:link] if item[:pid] == pid}
      @site.scrape_by_pid(@url+pid_link)
    end

    def items_with_price
      search_by_type.select{|item| item if item[:price] != nil}
    end

    def get_link_from_key
      @site.menu_hash.fetch(self.category)
    end

  end

  module Sortable

    def sort_by_price
      binding.pry
      items_with_price.sort{|a,b| a[:price] <=> b[:price]}
    end

  end

  module Printable

    def print_items_by_price
      sort_by_price.each{|item| puts "PID: #{item[:pid]} :#{item[:title]} $#{item[:price]}"}
    end

    def print_item_by_pid(pid)
      search_by_pid(pid)
    end

  end

  module Statistical

    def basic_stats
      values = items_with_price.collect{|item| item[:price]}
      if values != [nil]
        @basic_stats[:volume] = values.count
        @basic_stats[:mean] = values.reduce(:+)/@basic_stats[:volume]
        @basic_stats[:min] = values.min
        @basic_stats[:max] = values.max
      end
      @basic_stats
    end

  end

end
