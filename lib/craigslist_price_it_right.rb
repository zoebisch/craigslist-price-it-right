require_relative "./craigslist_price_it_right/version"

class CraigslistPriceItRight::CLI
  def main_menu
    puts "----------------------------------------------"
    puts "       !Welcome to Price it Right!"
    puts "     A Friendly Price Scraper for CL"
    puts "  To Begin, Let's Set the Default Page."
    puts "Please copy and paste the main CraigsList URL"
    puts "  (e.g. https://seattle.craigslist.org)"
    puts "----------------------------------------------"
  end

  def call
    main_menu
    url = gets.chomp.downcase
    url == "" ? url = "https://seattle.craigslist.org" : url
    PriceManager.new(url).call
  end
end
