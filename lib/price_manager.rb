#require 'pry'
require_relative './concerns/concerns.rb'

class PriceManager
  attr_accessor :category, :item, :pid, :min, :max, :stats
  attr_reader :url, :menu, :site
  include Concerns::Searchable
  include Concerns::Sortable
  include Concerns::Printable
  include Concerns::Statistical
  include Concerns::Mergable
  MENU = ["                                    ",
          "Available Actions:",
          "------------------------------------",
          "category -> View and Select Category",
          "view     -> View Items in Category",
          "item     -> Enter Search Item",
          "price    -> View Price Information",
          "range    -> View Item in Range",
          "pid      -> View Item Advanced Info",
          "q        -> Quit",
          "------------------------------------",
          "Please type in your selection",
          "------------------------------------"]

  def initialize(url)
    @url = url
    puts "OK, we are working with #{@url}"
    @site = CL_Scraper.new(@url)
    @menu = @site.scrape_for_sale_categories
    @stats = {}
  end

  def call
    process_category
    print_items_in_category
    process_item
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
      when "range"
        process_range
      when "pid"
        process_pid
      when "reset"
        reset
      when "debug"
      #  binding.pry
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
    #@site.scrape_page(get_link_from_key) #Scrape by individual page, safe for testing
    @site.scrape_category(get_link_from_key) #Warning An IP Ban is possible!
    Item.create_from_collection(@site.all)
    merge_price_manager_attr
  end

  def process_item
    puts "Please Enter your sale item:"
    @item = gets.chomp.downcase
    search_by_type
    process_price
  end

  def process_pid
    puts "Please Enter the PID:"
    @pid = gets.chomp
    if search_by_pid != nil
      item_details = @site.scrape_by_pid(@url+search_by_pid[0].link)
      Item.merge_item(@pid, item_details)
      print_item_by_pid
    else
      puts "PID: #{@pid} no longer available"
      print_item_by_pid
    end
  end

  def process_price
    print_items_by_price
    print_basic_stats
  end

  def process_range
    puts "Enter a minimum price"
    @min = gets.chomp.to_i
    puts "Enter a maximum price"
    @max = gets.chomp.to_i
    print_items_in_range
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
    if !@menu.has_key?(@category)
      puts "Category: #{@category} not found! Please check the spelling."
      sleep 1
      category_menu
    end
  end

end
