require 'pry'
require_relative './concerns/concerns.rb'

class PriceManager
  attr_accessor :category, :subcategory, :item, :pid, :min, :max, :stats
  attr_reader :url, :menu, :site
  include Concerns::Searchable
  include Concerns::Sortable
  include Concerns::Printable
  include Concerns::Statistical
  include Concerns::Mergable
  MENU =  ["\n",
          "Available Actions:",
          "----------------------------------------------",
          "category -> View and Select Category",
          "view     -> View Items in Category",
          "item     -> Enter Search Item",
          "price    -> View Price Information",
          "range    -> View Items in Range",
          "pid      -> View Item Advanced Info",
          "q        -> Quit",
          "----------------------------------------------",
          "Please type in your selection",
          "----------------------------------------------"]

  def initialize(url)
    @url = url
    puts "OK, we are working with #{@url}"
    sleep 1
    @site = CL_Scraper.new(@url)
    @site.scrape_for_sale_categories
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
      when "debug"
        binding.pry
      when "q"
        run = false
      end
    end

  end

  def actions_menu
    MENU.each{|message| puts "#{message}"}
    gets.chomp
  end

  def process_category
    #@site.scrape_category(check_subcategory_menu)
    @site.scrape_page(category_menu)
    Item.create_from_collection(@site.all)
    merge_price_manager_attr #If we select the same category, the data may have updated or stay same, avoid duplicates.
    print_items_in_category
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
    if search_by_pid != []
      item_details = @site.scrape_by_pid(@url+search_by_pid[0].link)
      Item.merge_item(@pid, item_details)
      print_item_by_pid
    else
      puts "PID: #{@pid} unavailable in #{@category}"
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
    puts "\n"
    puts "Available 'for sale' categories are:"
    puts "----------------------------------------------"
    @site.menu_hash.each_key{|key| puts key}
    puts "----------------------------------------------"
    puts "Enter the category you want to browse"
    puts "----------------------------------------------"
    @category = gets.strip.downcase
    unless @site.menu_hash.has_key?(@category)
      puts "Category: #{@category} not found! Please check the spelling."
      sleep 1
      category_menu
    end
    check_subcategory_menu
  end

  def check_subcategory_menu
    list = ["auto parts", "bikes", "boats", "cars+trucks", "computers", "motorcycles"]
    if list.include?(@category)
      @site.scrape_second_level_menus(get_link_from_key)
      subcategory_menu
    else
      get_link_from_key
    end
  end

  def subcategory_menu
    puts "\n"
    puts "----------------------------------------------"
    puts "Available categories in #{@category} are:"
    puts "----------------------------------------------"
    @site.submenu_hash.each_key{|key| puts key}
    puts "----------------------------------------------"
    puts "Enter the subcategory you want to browse"
    puts "----------------------------------------------"
    @subcategory = gets.strip
    unless @site.submenu_hash.has_key?(@subcategory)
      puts "\n"
      puts "******************************************************************"
      puts "Subcategory: #{@subcategory} not found! Please check the spelling."
      puts "******************************************************************"
      sleep 1 #pause so user can see warning
      subcategory_menu
    else
      puts "\n"
      puts "Please type in a selection from the following:"
      puts "----------------------------------------------"
      @site.submenu_hash.fetch(@subcategory).each_key{|key| puts key.downcase}
      puts "----------------------------------------------"
      @url + @site.submenu_hash.fetch(@subcategory).fetch(gets.strip.upcase)
    end
  end

end
