class Item
  attr_accessor :link, :pid, :title, :price, :condition, :location, :postingbody, :make, :model, :size, :timeago,
                :other_ads, :VIN, :fuel, :paint, :title, :transmission, :drive
  @@all = []

  def initialize(item_hash)
    item_hash.each{|key,value| self.send("#{key}=", value)}
    @@all << self
  end

  def merge_by_pid
    binding.pry
  end

  def self.create_from_collection(site_hash)
    site_hash.each{|hash| Item.new(hash)}
  end

  def self.all
    @@all
  end

end
