require 'pry'
require_relative './concerns/concerns.rb'

require_relative './craigslist_scraper.rb'
require_relative './item.rb'
class PriceManager
  attr_accessor :category, :item, :menu_hash
  include Concerns::Searchable
  MENU = ["------------------------------------",
          "!Welcome to The Price is Right!",
          "A Friendly Price Scraper for CL",
          "To Begin, Let's Set the Default Page:",
          "Please copy and paste the main CraigsList page and hit return.",
          # "Select From the Following:",
          # "------------------------------------",
          # "1. Set Default CraigsList Page",
          # "2. View and Select Category",
          # "3. View Price Information",
          # "------------------------------------",
          # "Please enter a numerical selection 1:3"
        ]

  def call
    MENU.each{|message| puts "#{message}"}
    url = gets.chomp.downcase
    puts "OK, let's get a menu from #{url}"
    @site = CL_Scraper.new(url="https://pennstate.craigslist.org")
    sleep 2
    @category = category_menu #TODO handle nil response
    @site.scrape_page(get_link_from_key)
    # case command
    # when 1
    #   puts "Please copy and paste the main CraigsList page and hit return"
    #   url = gets.chomp
    # when 2
    #   @category = category_menu
    #   blah.scrape_page(get_link_from_key)
    # when 3
    #
    # else
    #   call
    # end
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
    if CL_Scraper.menu_hash != {}
      CL_Scraper.menu_hash.each_key{|key| puts key}
    else
      @site = CL_Scraper.new(url)
    end
    puts "Enter the category you want to browse"
    puts "-------------------------------------"
    gets.strip.downcase
  end

end
PriceManager.new.call
