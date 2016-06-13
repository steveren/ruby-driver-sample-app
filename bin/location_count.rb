#!/usr/bin/ruby

require 'mongo'

# set logger level to FATAL (only show serious errors)
Mongo::Logger.logger.level = ::Logger::FATAL

# set up a connection to the mongod instance which is running locally,
# on the default port 27017
client = Mongo::Client.new([ '127.0.0.1:27017' ], :database => 'test')
restaurants = client[:restaurants]
neighborhoods = client[:neighborhoods]

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