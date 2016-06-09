#!/usr/bin/ruby

require 'mongo'

client = Mongo::Client.new([ '127.0.0.1:27017' ], :database => 'test')
coll = client[:restaurants]

puts "\nReady to input a new restaurant document.\n"
puts "First, the required fields.\n\n"

puts "Restaurant name:\n"

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

puts "Location coordinates (longitude, latitude):\n"

longlat_string = gets.chomp

categories = []
categories_string.split(',').each do |c|
  categories << c.strip
end

grades = []
grades_string.split(',').each do |g|
  grades << g.to_i
end 
longlat = longlat_string.split(',')

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

result = coll.insert_one( insert_doc )

result.n == 1 ? puts "Document successfully created." : puts "Document creation failed."