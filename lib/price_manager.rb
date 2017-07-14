require 'pry'
require_relative './concerns/concerns.rb'

require_relative './craigslist_scraper.rb'
require_relative './item.rb'
class PriceManager
  attr_accessor :category, :item, :menu_hash
  include Concerns::Searchable
  #MENU = []

  def call
    url = "https://seattle.craigslist.org"
    CL_Scraper.new(url, "antiques").scrape_page("https://seattle.craigslist.org/search/ata")
    #CL_Scraper.new(url,"furniture").scrape_category
    Item.create_from_collection
    Item.search_by_type("table")
    Item.sort_by_price
    Item.basic_stats
    @category = category_menu
    get_link_from_key
    binding.pry
  end

  def category_menu
    puts "------------------------------------"
    puts "Available 'for sale' categories are:"
    puts "------------------------------------"
    CL_Scraper.menu_hash.each_key{|key| puts key}
    puts "Enter the category you want to browse"
    gets.strip.downcase
  end

end
PriceManager.new.call
