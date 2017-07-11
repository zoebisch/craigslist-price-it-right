require 'pry'
require_relative './concerns/concerns.rb'

require_relative './craigslist_scraper.rb'
require_relative './item.rb'
class PriceManager
  attr_accessor :category, :item
  #MENU = []

  def call
    url = "https://seattle.craigslist.org"
    CL_Scraper.new(url,"furniture").scrape_category
    Item.create_from_collection
    Item.search_by_type("bed")
    Item.sort_by_price
    Item.basic_stats
    binding.pry
  end

end
PriceManager.new.call
