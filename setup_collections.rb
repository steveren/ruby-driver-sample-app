#!/usr/bin/ruby

require 'mongo'

client = Mongo::Client.new([ '127.0.0.1:27017' ], :database => 'test')
db = client.database

client[:restaurants].indexes.create_many([
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

client[:neighborhoods].indexes.create_one({ 'geometry' => '2dsphere' })