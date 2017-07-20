class Item
  attr_accessor :link, :pid, :title, :price, :condition, :location, :postingbody, :make, :model, :size, :timeago,
                :other_ads, :VIN, :fuel, :paint, :title, :transmission, :drive, :year, :number, :cylinders, :odometer, :venue,
                :type
  @@all = []

  def initialize(item_hash)
    item_hash.each{|key,value| self.send("#{key}=", value)}
  #  Item.mass_assign(self,item_hash)
    @@all << self
  end

  def self.merge_item(pid, item_details)
    item = Item.all.select{|item| item.pid == pid.to_s}
    item_details[0].each_pair{|key,value| item[0].send("#{key}=", value)}
    binding.pry
    #Item.mass_assign(item[0],item_details)
  end

  # def self.mass_assign(item, item_hash)
  #   item_hash.each{|key,value| item.send("#{key}=", value)}
  # end

  def self.create_from_collection(site_hash)
    site_hash.each{|hash| Item.new(hash)}
  end

  def self.all
    @@all
  end

end
