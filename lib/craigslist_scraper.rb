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
  end

  def self.scrape_for_sale_categories
    index_url = route_through_proxy(@url)
    main_page = Nokogiri::HTML(index_url)
    trim_url = index_url.gsub(/.org\//, ".org")
    hash = {}
    sss = main_page.search("#center #sss a")
    sss.each{|category| @@menu_hash[category.children.text] = trim_url + category.attribute("href").text}
    binding.pry
  end

  def scrape_category
    index_url = route_through_proxy(@url + "/search/" + @category)
    binding.pry
    listings = Nokogiri::HTML(index_url)
    num_listings = listings.search(".totalcount").first.text.to_i
    num_per_page = 120
    page_count = 1
    while page_count <= (num_listings/num_per_page).floor
      page_url = index_url + "?s=" + "#{page_count*120}"
      scrape_page(route_through_proxy(page_url))
      page_count += 1
    end
  end

  def scrape_page(page_url)
    puts "Scraping #{page_url}"
    listings = Nokogiri::HTML(page_url)
    binding.pry
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

  def route_through_proxy(url)
    # http = Net::HTTP::SOCKSProxy("47.44.40.8", 47251)
    # url = http.get(URI(url))
    blah = Nokogiri::HTML(url)
    binding.pry
  end

  def self.all
    @@all
  end

  def self.menu_hash
    @@menu_hash
  end

end
