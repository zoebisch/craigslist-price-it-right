module Concerns

  module Searchable

    def search_items
      Item.all.select{|item| yield(item)}
    end

    def search_by_type
      search_items{|item| item if item.title.include?(self.item)}
    end

    def search_by_category
      search_items{|item| item if item.category == @category}
    end

    def search_by_pid
      search_items{|item| item.pid == @pid}.first
    end

    def items_with_price
      search_by_type.select{|item| item if item.price}
    end

    def items_in_price_range
      items_with_price.select{|item| item if item.price.between?(@min,@max)}
    end

    def get_link_from_key
      @site.menu_hash.fetch(self.category)
    end

    def get_subcategory_info
      @site.submenu_hash.fetch(@subcategory)
    end

  end

  module Sortable

    def sort_by_price
      items_with_price.sort{|a,b| a.price <=> b.price}
    end

    def sort_by_location
      search_by_type.sort{|a,b| a.location <=> b.location}
    end

  end

  module Printable

    def print_items_in_category
      search_by_category.each{|item| puts "pid: #{item.pid} :#{item.title} $#{item.price}"}
      puts "There are a total of #{search_by_category.length} items in #{@category}"
    end

    def print_items_by_price
      sort_by_price.each{|item| puts "pid: #{item.pid} :#{item.title} $#{item.price}"}
    end

    def print_item_by_pid
      item = search_by_pid
      item.instance_variables.each{|var| puts "#{var.to_s.gsub(/@/,"")}: #{item.instance_variable_get(var)}"} #We cannot know ahead of time which attributes will be populated!
    end

    def print_basic_stats
      basic_stats{items_with_price}.each_pair{|key,val| puts "#{key} is #{val}"}
    end

    def print_items_in_range
      items_in_price_range.each{|item| puts "pid: #{item.pid} :#{item.title} $#{item.price}"}
      puts "#{items_in_price_range.length} #{@item} found in #{@category} between $#{@min} and $#{@max}"
      basic_stats{items_in_price_range}.each_pair{|key,val| puts "#{key} is #{val}"}
    end

  end

  module Mergable

    def merge_price_manager_attr
      Item.all.each do |item|
       item.category = @category if item.category == nil
       item.url = @url if item.url == nil
     end
    end

    def merge_item(pid, item_details)
      item = search_items{|item| item.pid == pid.to_s}.first
      item_details.first.each_pair{|key,value| item.send("#{key}=", value)}
    end

  end

  module Statistical

    def basic_stats
      values = yield.collect{|item| item.price}
      if values != []
        @stats[:volume] = values.count
        @stats[:mean] = values.reduce(:+)/@stats[:volume]
        @stats[:min] = values.min
        @stats[:max] = values.max
      end
      @stats
    end

  end

end
