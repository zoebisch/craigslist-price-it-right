
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

  module Sortable

    def sort_by_price
      items_with_price.sort{|a,b| a.price <=> b.price}
    end

  end

  module Statistical
    attr_accessor :volume, :mean, :low, :high

    def basic_stats
      sum = 0
      values = []
      binding.pry

      @price_list.each{|item| sum += item[:price]}
      @price_list.each{|item| values << item[:price]}
      @volume = @price_list.size
      @mean = sum/@volume
      @low = values.first
      @high = values.last
    end
  end

end
