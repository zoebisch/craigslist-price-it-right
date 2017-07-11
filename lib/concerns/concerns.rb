
module Concerns

  module Searchable

    def search_by_type(search_item)
      search_item = " " + search_item + " "
      self.all.select{|item| item if item.title.include?(search_item)}
    end

    def sort_by_price(list)
      value_items = []
      list.each{|item| value_items << item if item[:price] != nil}
      value_items.sort{|a,b| a[:price] <=> b[:price]}
    end

    def compile_by_name
      # list = self.all.sort{|a,b| a.name <=> b.name}.uniq
      # Item.all.each do |item|
      #   if item[:title].include?(CL_Scraper.item)
      #     puts "found #{CL_Scraper.item} in item, #{item.listing}"
      #   end
      # end
      # list.each_with_index{|obj,ind| yield(obj,ind)}
    end

  end

  module Statistical
    attr_accessor :volume, :mean, :low, :high

    def basic_stats(list)
      sum = 0
      values = []
      list.each{|item| sum += item[:price]}
      list.each{|item| values << item[:price]}

      @volume = values.size
      @mean = sum/@volume
      @low = values.first
      @high = values.last
    end
  end

end
