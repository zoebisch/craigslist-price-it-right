require 'open-uri'
require 'nokogiri'
require 'pry'

class CL_Scraper
  attr_reader :item, :category

  def initialize(url="https://seattle.craigslist.org", category)
    @url = url if url
    @category = category
  end

  def scrape_category
    index_url = "https://seattle.craigslist.org/search/fua"
    listings = Nokogiri::HTML(open(index_url))
    item_array = []
    item_list = listings.search(".rows .result-row")
    item_list.each do |item| #Collect and parse item data
      item_info = {}
      item_info[:pid] = item.attribute("data-pid").text
      item_info[:link] = item.search("a")[1].attribute("href").text
      item_info[:price] = item.search(".result-price").first.text if item.search(".result-price").first != nil
      item_info[:title] = item.search(".result-title").text
      item_info[:location] = item.search(".result-info .result-meta .result-hood").text
      item_array << item_info
    end
    item_array
  end

end
