#!/usr/bin/ruby

require 'mongo'
require 'optparse'

def list_neighborhoods(letter)
  
  # use a regular expression to find all neighborhoods starting
  # with a specified letter
  regex = Regexp.new("^#{letter.upcase}")
  n_list =  @neighborhoods.find({ "name" => regex }, { "name" => 1, "_id" => 0 }).sort({ :name => 1 })

  puts "\nNeighborhoods beginning with #{letter.upcase}:\n\n"

  n_list.each { |n| puts "#{n[:name]}\n" }
  
  puts "\n"
end

def find_restaurants(n)
  
  # first check that the specified neighborhood exists
  result = @neighborhoods.find({ "name" => n }).first

  if result

    puts "\nAll restaurants found in #{n}:\n\n"

    restaurants = @restaurants.find( { 
      "contact.location" => 
        { "$geoWithin" => 
          { "$geometry" => result[:geometry] } 
        } 
      } ).sort({ :name => 1 })
    
    restaurants.each do |r|
      puts r[:name] unless r[:name].empty?
    end    

  else

    puts "\nThat neighborhood is not in the database. You can try again,
or use 'find_nearby.rb --list' to see a list of neighborhoods.\n\n"

  end
  
end

# set logger level to FATAL (only show serious errors)
Mongo::Logger.logger.level = ::Logger::FATAL

# set up a connection to the mongod instance which is running locally,
# on the default port 27017
client = Mongo::Client.new([ '127.0.0.1:27017' ], :database => 'test')
@restaurants = client[:restaurants]
@neighborhoods = client[:neighborhoods]

# parse command-line options
options = { :neighborhood => nil, :list => nil }
optparse = OptionParser.new do |opt|
  opt.on('-n', '--neighborhood NEIGHBORHOOD', 'list restaurants in this neighborhood') { |o| options[:neighborhood] = o }
  opt.on('-l', '--list LETTER', 'list all neighborhoods starting with this letter') {|o| options[:list] = o }
end

begin
  optparse.parse!
rescue OptionParser::MissingArgument
  puts "\nUse -l <letter> to see all neighborhoods which begin with that letter.\n"
  puts "\nUse -n <neighborhood> to see all restaurants in that neighborhood.\n"  
end

if options[:neighborhood]
  find_restaurants(options[:neighborhood])
elsif options[:list]
  list_neighborhoods(options[:list])
else
  puts "\nFor usage options, type ./find_nearby --help\n\n"
end
