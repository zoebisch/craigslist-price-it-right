require 'pry'
require_relative './concerns/concerns.rb'

class PriceManager
  attr_accessor :category, :item, :items, :site, :pid
  attr_reader :url, :menu
  include Concerns::Searchable
  include Concerns::Sortable
  include Concerns::Printable
  include Concerns::Statistical
  MENU = ["                                    ",
          "Available Actions:",
          "------------------------------------",
          "category -> View and Select Category",
          "view     -> View Items in Category",
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
    @basic_stats = {}
  end

  def call
    process_category
    print_items_in_category
    process_item
    process_price
    run = true
    while run
      case actions_menu
      when "category"
        process_category
      when "view"
        print_items_in_category
      when "item"
        process_item
      when "price"
        process_price
      when "pid"
        process_pid
      when "reset"
        reset
      when "q"
        run = false
      end
    end

  end

  def reset
    binding.pry
      @basic_stats.clear
      call
  end

  def actions_menu
    MENU.each{|message| puts "#{message}"}
    gets.chomp
  end

  def process_category
    category_menu
    @site.scrape_page(get_link_from_key)
    #@site.scrape_category(get_link_from_key) #Warning An IP Ban is possible!
    @items = Item.create_from_collection(@site.all)
  end

  def process_item
    puts "Please Enter your sale item:"
    @item = gets.chomp.downcase
    search_by_type
  end

  def process_pid
    puts "Please Enter the PID:"
    @pid = gets.chomp
    if search_by_pid != nil
      item_details = @site.scrape_by_pid(@url+search_by_pid[0][:link])
      Item.merge_item(@pid, item_details)
      print_item_by_pid
    else
      puts "PID: #{@pid} no longer available"
      print_item_by_pid
      process_pid
    end
  end

  def process_price
    print_items_by_price
    print_basic_stats
  end

  def category_menu
    puts "                                     "
    puts "-------------------------------------"
    puts "Available 'for sale' categories are:"
    puts "-------------------------------------"
    @menu.each_key{|key| puts key}
    puts "Enter the category you want to browse"
    puts "-------------------------------------"
    @category = gets.strip.downcase
    category_menu if !@menu.has_key?(@category)
  end

end
