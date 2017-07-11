require 'pry'
require_relative './concerns/concerns.rb'

require_relative './craigslist_scraper.rb'
require_relative './item.rb'
class PriceManager
  @list = []
  include Concerns::Searchable
  include Concerns::Statistical
  #MENU = []

  def call
    url = "https://seattle.craigslist.org"
    item_array = CL_Scraper.new(url,"furniture").scrape_category
    @list = Item.create_from_collection(item_array)
    results = search_by_type("bed")
    blah = sort_by_price(results)
    find_stats(blah) if blah != []
    binding.pry
  end
  
end
PriceManager.new.call
