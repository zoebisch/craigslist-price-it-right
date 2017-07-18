require 'open-uri'
require 'nokogiri'
require 'pry'

class CL_Scraper
  USER_AGENT = "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36"
  attr_accessor :menu_hash, :all
  @@all = []

  def initialize(url)
    @all = []
    @url = url if url
    @menu_hash = {}
    @@all << self
  end

  def scrape_for_sale_categories
    sss = noko_page.search("#center #sss a")
    sss.each{|category| @menu_hash[category.children.text] = @url + category.attribute("href").text}
    @menu_hash
    #TODO: bikes, boats, autos, auto_parts all need to be drilled into
  end

  def scrape_category
    binding.pry
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
    item_list.each do |item|
      item_info = {}
      item_info[:pid] = item.attribute("data-pid").text
      item_info[:link] = item.search("a")[1].attribute("href").text
      item_info[:price] = item.search(".result-price").first.text.gsub(/\$/, "").to_i if item.search(".result-price").first != nil
      item_info[:title] = item.search(".result-title").text.downcase
      item_info[:location] = item.search(".result-info .result-meta .result-hood").text
      @all << item_info
    end
  end

  def scrape_by_pid(pid_link)
    puts "Scraping #{pid_link}"
    listing = noko_page(pid_link)
    listing.search(".rows .result-row")
    item_info = {}
    item_info[:postingbody] = listing.search("#postingbody").text
    attrgroup = listing.search(".attrgroup span").text.split("/")
    attrgroup.each do |attribute|
      binding.pry
    end
    # item_info[:]
    item_info[:timeago] = listing.search(".timeago")[0].text
    # item_info[:price] = item.search(".result-price").first.text.gsub(/\$/, "").to_i if item.search(".result-price").first != nil
    # item_info[:title] = item.search(".result-title").text.downcase
    # item_info[:location] = item.search(".result-info .result-meta .result-hood").text
    item_info
  end

  def noko_page(page=@url)
    Nokogiri::HTML(open(page, 'User-Agent' => USER_AGENT))
  end

  def self.all
    @@all
  end

end
