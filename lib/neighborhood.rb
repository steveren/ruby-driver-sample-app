class Neighborhood
  
  def list_neighborhoods(letter, collection)
  
    # use a regular expression to find all neighborhoods starting
    # with a specified letter
    regex = Regexp.new("^#{letter.upcase}")
    n_list = collection.find({ "name" => regex }, { "name" => 1, "_id" => 0 }).sort({ :name => 1 })
  end

  def neighborhood_check(n, collection)
    result = collection.find({ "name" => n }).first    
  end
  
  def find_restaurants(neighborhood, neighborhoods_collection, restaurants_collection)
  
      r_list = restaurants_collection.find( { 
        "contact.location" => 
          { "$geoWithin" => 
            { "$geometry" => neighborhood[:geometry] } 
          } 
        } ).sort({ :name => 1 })
          
  end
  
end