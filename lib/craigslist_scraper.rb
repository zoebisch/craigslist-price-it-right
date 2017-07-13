require 'open-uri'
require 'nokogiri'
require 'socksify/http'
require 'pry'

class CL_Scraper
  attr_reader :item, :category
  @@all = []
  @@menu_hash = {}

  def initialize(url="https://seattle.craigslist.org", category)
    @category = category if category
    @url = url if url
    @user_agent = "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36"
  end

  def self.scrape_for_sale_categories
    binding.pry
    main_page = Nokogiri::HTML(open(@url, 'User-Agent' => @user_agent)) #user_agent is critical to bypassing IP Ban
    trim_url = index_url.gsub(/.org\//, ".org")
    hash = {}
    sss = main_page.search("#center #sss a")
    sss.each{|category| @@menu_hash[category.children.text] = trim_url + category.attribute("href").text}
  end

  def scrape_category
    index_url = @url + "/search/" + @category
    listings = Nokogiri::HTML(open(index_url, 'User-Agent' => @user_agent))
    num_listings = listings.search(".totalcount").first.text.to_i
    num_per_page = 120
    page_count = 1
    while page_count <= (num_listings/num_per_page).floor
      page_url = index_url + "?s=" + "#{page_count*120}"
      scrape_page(page_url)
      sleep 5           #Sleep to aviod CL API from banning IP!
      page_count += 1
    end
  end

  def scrape_page(page_url)
    puts "Scraping #{page_url}"
    listings = Nokogiri::HTML(open(page_url, 'User-Agent' => @user_agent))
    item_array = []
    item_list = listings.search(".rows .result-row")
    item_list.each do |item| #Collect and parse item data
      item_info = {}
      item_info[:pid] = item.attribute("data-pid").text
      item_info[:link] = item.search("a")[1].attribute("href").text
      item_info[:price] = item.search(".result-price").first.text.gsub(/\$/, "").to_i if item.search(".result-price").first != nil
      item_info[:title] = item.search(".result-title").text.downcase
      item_info[:location] = item.search(".result-info .result-meta .result-hood").text
      @@all << item_info
    end
  end

  def self.all
    @@all
  end

  def self.menu_hash
    @@menu_hash
  end

end
