class Item
  attr_accessor :category, :url, :link, :pid, :title, :price, :condition, :location, :postingbody, :make, :model, :size, :timeago,
  :other_ads, :VIN, :fuel, :paint, :title, :transmission, :drive, :year, :number, :cylinders, :odometer, :venue, :venue_date, :type
  extend Concerns::Searchable
  extend Concerns::Mergable
  @@all = []

  def initialize(item_hash)
    item_hash.each{|key,value| self.send("#{key}=", value)}
    @@all << self if @@all.none?{|item| item.pid == self.pid}
  end

  def self.create_from_collection(site_hash)
    site_hash.each{|hash| Item.new(hash)}
  end

  def self.all
    @@all
  end

end
