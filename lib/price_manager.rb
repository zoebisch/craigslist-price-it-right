require 'pry'
require_relative './concerns/concerns.rb'

require_relative './craigslist_scraper.rb'
require_relative './item.rb'
class PriceManager
  attr_accessor :category, :item, :menu_hash
  #MENU = []

  def call
    url = "https://seattle.craigslist.org"
    CL_Scraper.new(url,"furniture").scrape_category
    #CL_Scraper.new(url,"furniture").scrape_page()
    Item.create_from_collection
    Item.search_by_type("bed")
    Item.sort_by_price
    Item.basic_stats
    @category = category_menu
    get_link_from_key
    binding.pry
  end

  def category_menu
    puts "__________________________________"
    puts "Available 'for sale' categories are:"
    CL_Scraper.scrape_for_sale_categories
    CL_Scraper.menu_hash.each_key{|key| puts key}
    puts "Enter the category you want to browse"
    gets.strip.downcase
  end

end
PriceManager.new.call
