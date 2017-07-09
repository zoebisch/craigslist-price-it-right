require 'open-uri'
require 'nokogiri'
require 'pry'

class CL_Scraper
  attr_reader :item, :category
  attr_accessor :link, :id, :description, :price, :condition, :location, :flag
  @@items = []

  def initialize(item, category)
    @item = item
    @category = category
  end

  def scrape_category
    index_url = "https://seattle.craigslist.org/search/fua"
    listings = Nokogiri::HTML(open(index_url))

    item_list = listings.search(".rows .result-row")
    item_list.each do |item| #Collect and parse item data
      item_info = {}
      item_info[:link] = item.search("a").attribute("href").text
      item_info[:price] = item.search(".result-price").first.text if item.search(".result-price").first != nil
      item_info[:words] = item.search(".result-title").text
      item_info[:location] = item.search(".result-info .result-meta .result-hood").text
      @@items << item_info
    end
    @@items
  end
  #item_info[:id] = item.search("a").attribute("data-id").text
  #item_info[:condition] =
  def all
    @@items
  end

end


scraped = CL_Scraper.new("chair", "furniture")
scraped.scrape_category
puts "#{scraped.all}"
