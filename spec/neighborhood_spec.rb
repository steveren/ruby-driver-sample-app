require 'mongo'
require 'neighborhood'
require 'connection'

describe Neighborhood do

  conn = Connection.new
  neighborhoods = conn.neighborhoods
  restaurants = conn.restaurants
  
  n = Neighborhood.new
  
  describe ".list_neighborhoods" do
    context "given a letter with no results" do
      it "returns an empty result" do
        n_list = n.list_neighborhoods("x", neighborhoods)
        expect(n_list.to_a.length).to eql(0)
      end
    end
    
    context "given a letter with results" do
      it "returns some results" do
        n_list = n.list_neighborhoods("M", neighborhoods)
        expect(n_list.to_a.length).to be > 0        
      end
      
      it "is case insensitive" do
        n_list = n.list_neighborhoods("m", neighborhoods)
        n_list2 = n.list_neighborhoods("M", neighborhoods)
        expect(n_list).to eql(n_list2)                 
      end
      
      it "sorts in lexical order" do
        n_list = n.list_neighborhoods("m", neighborhoods)
        names_array = []
        n_list.each do |doc|
          names_array << doc[:name]
        end
        expect(names_array).to eql(names_array.sort)
      end
    end
  end
  
  describe ".neighborhood_check" do
    context "given a real neighborhood" do
      it "returns true" do
        result = n.neighborhood_check("Midwood", neighborhoods)
        expect(result).to be_truthy
      end
    end
    
    context "given a nonexistent neighborhood" do
      it "returns false" do
        result = n.neighborhood_check("Nowheresville", neighborhoods)
        expect(result).to be_nil
      end
    end
  end
  
  describe ".find_restaurants" do
    context "given a neighborhood that exists" do
      it "returns a list of restaurants" do
        r = n.neighborhood_check("Midwood", neighborhoods)
        r_list = n.find_restaurants(r, neighborhoods, restaurants)
        expect(r_list.to_a.length).to be > 0
      end
      
      it "sorts in lexical order" do
        r = n.neighborhood_check("Midwood", neighborhoods)
        r_list = n.find_restaurants(r, neighborhoods, restaurants)
        names_array = []
        r_list.each do |doc|
          names_array << doc[:name]
        end
        expect(names_array).to eql(names_array.sort)
      end
    end 
  end
end