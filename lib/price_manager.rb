require 'pry'
#require_relative './concerns/concerns'

require_relative './craigslist_scraper.rb'
require_relative './item.rb'
class PriceManager
  @list = []
  #extend Concerns::Searchable
  #MENU = []

  def call
    url = "https://seattle.craigslist.org"
    item_array = CL_Scraper.new(url,"furniture").scrape_category
    @list = Item.create_from_collection(item_array)
    results = search_by_type("chair")
    sort_by_price(results)
  end

  def search_by_type(search_item)
    results = []
    @list.each{|item| results << item if item[:title].include?(search_item)}
    results
  end

  def sort_by_price(list)
    value_items = []
    list.each{|item| value_items << item if item[:price] != nil}
    value_items.sort{|a,b| a[:price].gsub(/\$/, "").to_i <=> b[:price].gsub(/\$/, "").to_i}
  end

end
PriceManager.new.call
