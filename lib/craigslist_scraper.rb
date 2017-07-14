require 'open-uri'
require 'nokogiri'
require 'pry'

class CL_Scraper
  USER_AGENT = "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36"
  @@all = []
  @@menu_hash = {}

  def initialize(url, category="antiques")
    @category = category if category
    @url = url if url
    scrape_for_sale_categories #Create menu hash on initialization
  end

  def scrape_for_sale_categories
    sss = noko_page.search("#center #sss a")
    sss.each{|category| @@menu_hash[category.children.text] = @url + category.attribute("href").text}
    #TODO: bikes, boats, autos, auto_parts all need to be drilled into
  end

  def scrape_category
    index_url = @url + "/search/" + @category
    listings = noko_page(index_url)
    num_listings = listings.search(".totalcount").first.text.to_i
    num_per_page = 120
    page_count = 1
    while page_count <= (num_listings/num_per_page).floor
      page_url = index_url + "?s=" + "#{page_count*num_per_page}"
      scrape_page(page_url)
      sleep rand(1..5)           #Sleep to help avoid CL API from banning IP!
      page_count += 1
    end
  end

  def scrape_page(page_url)
    puts "Scraping #{page_url}"
    listings = noko_page(page_url)
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

  def noko_page(page=@url)
    Nokogiri::HTML(open(page, 'User-Agent' => USER_AGENT))
  end

  def self.all
    @@all
  end

  def self.menu_hash
    @@menu_hash
  end

end
