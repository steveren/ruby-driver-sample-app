#!/usr/bin/ruby

require 'mongo'
require_relative '../lib/connection'

conn = Connection.new
restaurants = conn.restaurants
neighborhoods = conn.neighborhoods

restaurant_counts = {}

# get a list of neighborhoods
all_neighborhoods = neighborhoods.find()

# count all restaurants in each neighborhood
all_neighborhoods.each do |n|
  count = restaurants.count( { 
    "contact.location" => 
      { "$geoWithin" => 
        { "$geometry" => n[:geometry] } 
      } 
    } )
    restaurant_counts[n[:name]] = count
end

# display results
restaurant_counts.sort_by(&:last).reverse.each do |r|
  
  puts "#{r[0]} => #{r[1]}"
  
end