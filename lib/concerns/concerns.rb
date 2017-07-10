
module Concerns

  def compile_by_name
    # list = self.all.sort{|a,b| a.name <=> b.name}.uniq
    # Item.all.each do |item|
    #   if item[:title].include?(CL_Scraper.item)
    #     puts "found #{CL_Scraper.item} in item, #{item.listing}"
    #   end
    # end
    # list.each_with_index{|obj,ind| yield(obj,ind)}
  end

end
