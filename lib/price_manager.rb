require 'pry'
require_relative './concerns/concerns.rb'

class PriceManager
  attr_accessor :category, :item, :items, :items_with_price, :site, :menu_hash
  attr_reader :url
  include Concerns::Searchable
  include Concerns::Printable
  MENU = ["                                    ",
          "Available Actions:",
          "------------------------------------",
          "category -> View and Select Category",
          "item     -> Enter Search Item",
          "price    -> View Price Information",
          "pid      -> View Item Advanced Info",
          "q        -> Quit",
          "------------------------------------",
          "  Please type in your selection",
          "------------------------------------"]

  def initialize(url)
    @url = url
    @items = []
    puts "OK, we are working with #{@url}"
    @site = CL_Scraper.new(@url)
  end

  def call
    run = true
    while run
      case actions_menu
      when "category"
        @category = category_menu #TODO handle nil response
        @site.scrape_page(get_link_from_key)
        @items = Item.create_from_collection
      when "item"
        puts "Please Enter your sale item:"
        @item = gets.chomp.downcase
        @items_with_price = Item.search_by_type(@item)
      when "price"
        print_items_by_price
        @basic_stats = Item.basic_stats
      when "pid"
        puts "Please Enter the PID:"
        print_item_by_pid(gets.chomp)
      when "q"
        run = false
      end
    end

  end

  def actions_menu
    MENU.each{|message| puts "#{message}"}
    gets.chomp
  end

  def category_menu
    puts "                                     "
    puts "-------------------------------------"
    puts "Available 'for sale' categories are:"
    puts "-------------------------------------"
    binding.pry
    @site.menu_hash.each_key{|key| puts key}
    puts "Enter the category you want to browse"
    puts "-------------------------------------"
    gets.strip.downcase
  end

end
