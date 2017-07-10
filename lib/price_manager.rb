require 'pry'
require_relative 'craigslist_scraper.rb'
require_relative 'item.rb'
class PriceManager
  attr_accessor
  #MENU = []

  def call
    url = "https://seattle.craigslist.org"
    item_array = CL_Scraper.new(url,"furniture").scrape_category
    blah = Item.create_from_collection(item_array)
    binding.pry
  end

end
# scraped = CL_Scraper.new("chair", "furniture")
# blah = Item.create_from_collection(scraped.scrape_category)
PriceManager.new.call
binding.pry
