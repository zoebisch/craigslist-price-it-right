require 'pry'
require_relative './concerns/concerns.rb'

class PriceManager
  attr_accessor :category, :item, :items, :items_with_price, :site
  attr_reader :url, :menu
  include Concerns::Searchable
  include Concerns::Sortable
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
    @menu = @site.scrape_for_sale_categories
  end

  def call
    run = true
    while run
      case actions_menu
      when "category"
        @category = category_menu #TODO handle nil response
        @site.scrape_page(get_link_from_key)
        @items = Item.create_from_collection(@site.all)
      when "item"
        puts "Please Enter your sale item:"
        @item = gets.chomp.downcase
        @items_with_price = search_by_type(@item)
      when "price"
        print_items_by_price
        @basic_stats = basic_stats
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
    @menu.each_key{|key| puts key}
    puts "Enter the category you want to browse"
    puts "-------------------------------------"
    gets.strip.downcase
  end

end
