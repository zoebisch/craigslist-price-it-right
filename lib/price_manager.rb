class PriceManager
  attr_accessor
  #MENU = []
  def initialize(url="https://seattle.craigslist.org")
    @url = url
    CL_Scraper.new(url)
  end
end
# scraped = CL_Scraper.new("chair", "furniture")
# blah = Item.create_from_collection(scraped.scrape_category)
# binding.pry
