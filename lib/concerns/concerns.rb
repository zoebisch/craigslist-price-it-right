require 'pry'
module Concerns

  module Searchable

    def search_by_type
      Item.all.select{|item| item if item.title.include?(self.item)}
    end

    def search_by_category
      Item.all.select{|item| item if item.category == @category}
    end

    def search_by_pid
      Item.all.select{|item| item.pid == @pid}
    end

    def items_with_price
      search_by_type.select{|item| item if item.price != nil}
    end

    def items_in_price_range
      search_by_type.select{|item| item if item.price >= @min && item.price <= @max}
    end

    def get_link_from_key
      @site.menu_hash.fetch(self.category)
    end

  end

  module Sortable

    def sort_by_price
      items_with_price.sort{|a,b| a.price <=> b.price}
    end

  end

  module Printable

    def print_items_in_category
      search_by_category.each{|item| puts "PID: #{item.pid} :#{item.title} $#{item.price}"}
      puts "There are a total of #{search_by_category.length} items in #{@category}"
    end

    def print_items_by_price
      sort_by_price.each{|item| puts "PID: #{item.pid} :#{item.title} $#{item.price}"}
    end

    def print_item_by_pid
       item = search_by_pid[0]
       item.instance_variables.each{|var| puts "#{var} is #{item.instance_variable_get(var)}"}
    end

    def print_basic_stats
      basic_stats.each_pair{|key,val| puts "#{key} is #{val}"} if search_by_type != []
    end

  end

  module Mergable
    def merge_price_manager_attr
      Item.all.each do |item|
       item.category = @category if item.category == nil
       item.url = @url if item.url== nil
     end
    end

    def merge_item(pid, item_details)
      item = Item.all.select{|item| item.pid == pid.to_s}
      item_details[0].each_pair{|key,value| item[0].send("#{key}=", value)}
    end

  end

  module Statistical

    def basic_stats
      values = items_with_price.collect{|item| item.price}
      if values != [nil] || values != []
        @basic_stats[:volume] = values.count
        @basic_stats[:mean] = values.reduce(:+)/@basic_stats[:volume]
        @basic_stats[:min] = values.min
        @basic_stats[:max] = values.max
      end
      @basic_stats
    end

    def filter_by_price
      puts "Enter a minimum price"
      @min = gets.chomp.to_i
      puts "Enter a maximum price"
      @max = gets.chomp.to_i
      items_in_price_range
    end

  end

end
