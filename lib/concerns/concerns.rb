require 'pry'
module Concerns

  module Searchable
    attr_accessor :site
    @search_list = []

    def search_by_type
      @site.all.select{|item| item if item[:title].include?(self.item)}
    end

    def search_by_pid
      @items.select{|item| item[:pid] == @pid}
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
      items_with_price.sort{|a,b| a[:price] <=> b[:price]}
    end

  end

  module Printable

    def print_items_in_category
      @items.each{|item| puts "PID: #{item[:pid]} :#{item[:title]} $#{item[:price]}"}
      puts "There are a total of #{@items.length} items in #{@category}"
    end

    def print_items_by_price
      sort_by_price.each{|item| puts "PID: #{item[:pid]} :#{item[:title]} $#{item[:price]}"}
    end

    def print_item_by_pid
      binding.pry
      search_by_pid.each{|property| puts property.each_pair{}}
    end

    def print_basic_stats
      basic_stats.each_pair{|key,val| puts "#{key} is #{val}"} if search_by_type != []
    end

  end

  module Statistical

    def basic_stats
      values = items_with_price.collect{|item| item[:price]}
      if values != [nil] || values != []
        @basic_stats[:volume] = values.count
        @basic_stats[:mean] = values.reduce(:+)/@basic_stats[:volume]
        @basic_stats[:min] = values.min
        @basic_stats[:max] = values.max
      end
      @basic_stats
    end

  end

end
