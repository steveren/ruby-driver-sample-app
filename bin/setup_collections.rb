#!/usr/bin/ruby

require 'mongo'
require_relative '../lib/connection'

conn = Connection.new
db = conn.client.database
restaurants = conn.restaurants
neighborhoods = conn.neighborhoods


restaurants.indexes.create_many([
  { :key => { "name" => 1 }, "text" => true },
  { :key => { "contact.location" => 1 }, "2dsphere" => true },
  { :key => { "categories" => 1 }, "multikey" => true }
])

db.command({ 'collMod' => 'restaurants', 
             'validator' => 
               { 'name' => 
                 { '$type' => 'string' },  
                 'stars' => 
                 { '$type' => 'number' }
               }
            })

neighborhoods.indexes.create_one({ 'geometry' => '2dsphere' })