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
    blah= CL_Scraper.new(url)
    @category = category_menu
    blah.scrape_page(get_link_from_key)
    #CL_Scraper.new(get_link_from_key, @category).scrape_category
    #CL_Scraper.new(url,"furniture").scrape_category
    Item.create_from_collection
    Item.search_by_type("table")
    Item.sort_by_price
    Item.basic_stats
    binding.pry
  end

  def category_menu
    puts "-------------------------------------"
    puts "Available 'for sale' categories are:"
    puts "-------------------------------------"
    CL_Scraper.menu_hash.each_key{|key| puts key}
    puts "Enter the category you want to browse"
    puts "-------------------------------------"
    gets.strip.downcase
  end

end
PriceManager.new.call
