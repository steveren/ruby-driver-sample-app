#!/usr/bin/ruby

require 'mongo'
require 'optparse'
require_relative '../lib/neighborhood'
require_relative '../lib/connection'

conn = Connection.new

restaurants = conn.restaurants
neighborhoods = conn.neighborhoods

# parse command-line options
options = { :neighborhood => nil, :list => nil }
optparse = OptionParser.new do |opt|
  opt.on('-n', '--neighborhood NEIGHBORHOOD', 'list restaurants in this neighborhood') { |o| options[:neighborhood] = o }
  opt.on('-l', '--list LETTER', 'list all neighborhoods starting with this letter') { |o| options[:list] = o }
end

begin
  optparse.parse!
rescue OptionParser::MissingArgument
  puts "\nUse -l <letter> to see all neighborhoods which begin with that letter.\n"
  puts "\nUse -n <neighborhood> to see all restaurants in that neighborhood.\n"  
end

n = Neighborhood.new

if options[:neighborhood]
  
  n_name = options[:neighborhood]
  neighborhood = n.neighborhood_check(n_name, neighborhoods)
  
  if neighborhood
  
    r_list = n.find_restaurants(neighborhood, neighborhoods, restaurants)
    puts "\nAll restaurants found in #{n_name}:\n\n"
    r_list.each do |r|
      puts r[:name] unless r[:name].empty?
    end    
    
  else
    puts "\nThat neighborhood is not in the database. You can try again,
or use 'find_nearby.rb --list <letter>' to see a list of neighborhoods
which begin with <letter>.\n\n"
  end
  
elsif options[:list] 

  letter = options[:list]
  n_list = n.list_neighborhoods(letter, neighborhoods)
  
  if n_list.to_a.length > 0
    puts "\nNeighborhoods beginning with #{letter.upcase}:\n\n"
    n_list.each { |n| puts "#{n[:name]}\n" }
    puts "\n"
  else
    puts "\nSorry, there are no neighborhoods in the database which begin with '#{letter}'.\n\n"
  end
  
else
  puts "\nFor usage options, type ./find_nearby --help\n\n"
end
