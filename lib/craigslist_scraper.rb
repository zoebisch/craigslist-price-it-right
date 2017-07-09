require 'open-uri'
require 'nokogiri'
require 'pry'

class CL_Scraper
  attr_reader :item, :category
  attr_accessor :link, :id, :description

  def initialize(item, category)
    @item = item
    @category = category
  end

  def scrape_category
    index_url = "https://seattle.craigslist.org/search/fua"
    listings = Nokogiri::HTML(open(index_url))

    item_list = listings.search(".rows .result-row")
    binding.pry
    # students.each do |student|
    #   student_card = {}
    #
    #   student_card[:name] = student.search("a .student-name").text
    #   student_card[:location] = student.search("a .student-location").text
    #   student_card[:profile_url] = student.search(" a").attribute("href").text
    #
    #   scraped << student_card
    # end
    # scraped
    end

end


scraped = CL_Scraper.new("chair", "furniture")
scraped.scrape_category
