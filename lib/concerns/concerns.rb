require 'pry'
module Concerns

  module Searchable
    attr_accessor :site
    @search_list = []

    def search_by_type(search_item)
      #Extend this to check any of the item's scraped attributes
      @search_list = @site.all.select{|item| item if item[:title].include?(" " + search_item + " ")} #Spaces to help search scope
    end

    def search_by_pid(pid)
      pid_link = ""
      @search_list.select{|item| pid_link = item[:link] if item[:pid] == pid}
      @site.scrape_by_pid(@site.url+pid_link)
    end

    def items_with_price
      @search_list.select{|item| item if item[:price] != nil}
    end

    def get_link_from_key
      @site.menu_hash.fetch(self.category) #TODO: add check to prevent user input misspellings, etc
    end

  end

  module Sortable

    def sort_by_price
      items_with_price.sort{|a,b| a[:price] <=> b[:price]}
    end

  end

  module Printable

    def print_items_by_price
      sort_by_price.each{|item| puts "ID: #{item[:pid]} :#{item[:title]} $#{item[:price]}"}
    end

    def print_item_by_pid(pid)
      @items.search_by_pid(pid)
    end

  end

  module Statistical

    def basic_stats
      values = items_with_price.collect{|item| item[:price]}
      @basic_stats[:volume] = values.count
      @basic_stats[:mean] = values.reduce(:+)/@basic_stats[:volume] if @basic_stats[:volume]
      @basic_stats[:min] = values.min
      @basic_stats[:max] = values.max
      @basic_stats
    end

  end

end
