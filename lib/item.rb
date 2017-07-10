class Item
  attr_accessor :link, :pid, :title, :price, :condition, :location, :flag
  @@all = []

  def initialize(item_hash)
    item_hash.each {|key,value| self.send("#{key}=", value)}
    @@all << self
  end

  def self.create_from_collection(item_array)
    item_array.each{|hash| Item.new(hash)}
  end

  # def self.all
  #   @@all
  # end

end
