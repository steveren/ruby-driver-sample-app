#!/usr/bin/ruby

require 'mongo'
require_relative '../lib/connection'

conn = Connection.new
db = conn.client.database
restaurants = conn.restaurants

# prompt user for inputs
puts "\nReady to input a new restaurant document.\n"
puts "First, the required fields.\n\n"

puts "Restaurant name:\n"

# strip newline character from input with chomp
name = gets.chomp

puts "\nCategories (comma-separated list, e.g. French, BBQ, Tapas):\n"

categories_string = gets.chomp

puts "\nStars (number from 0 - 5):"

stars_string = gets.chomp

puts "\nNext, the optional fields.\n\n"

puts "\nGrades (comma-separated list of up to 5 numbers):\n"

grades_string = gets.chomp

puts "\nPhone number (format: 555-555-5555):\n"

phone = gets.chomp

puts "\nEmail address:\n"

email = gets.chomp

puts "\nLocation coordinates (longitude, latitude):\n"

longlat_string = gets.chomp

# remove whitespace from categories input and load each item into an array
categories = []
categories_string.split(',').each do |c|
  categories << c.strip
end

# convert grades to numbers and load into an array
grades = []
grades_string.split(',').each do |g|
  grades << g.to_i
end 

longlat = longlat_string.split(',')

# create a document for insertion
insert_doc = { 'name' => name, 
               'categories' => categories,
               'stars' => stars_string.to_i, 
               'grades' => grades,
               'contact' =>
                 { 'phone' => phone,
                   'email' => email,
                   'location' => longlat
                 }
             }

# use the insert_one method on the restaurants collection
result = restaurants.insert_one( insert_doc )

# check for success or failure
if result.n == 1
  puts "Document successfully created.\n#{insert_doc}"
else
  puts "Document creation failed."
end
