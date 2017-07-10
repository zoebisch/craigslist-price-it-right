require 'pry'
# module Concerns::Findable
#
#   def find_by_name(name)
#     self.all.detect{|obj| obj.name == name}
#   end
#
#   def find_or_create_by_name(name)
#     self.find_by_name(name) || self.create(name)
#   end
#
# end

module Concerns::Searchable

  def compile_by_name
    # list = self.all.sort{|a,b| a.name <=> b.name}.uniq
    binding.pry
    Item.all.each do |item|
      if item[:title].include?(CL_Scraper.item)
        puts "found #{CL_Scraper.item} in item, #{item.listing}"
      end
    end
    # list.each_with_index{|obj,ind| yield(obj,ind)}
  end

  # def list_songs_from(source)
  #   list = source.songs.sort{|a,b| a.name <=> b.name}.uniq
  #   list.each_with_index{|obj,ind| yield(obj,ind)}
  # end

end
