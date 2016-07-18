========================================================
Sample Application with the MongoDB Ruby Driver
========================================================

Overview
--------

This project demonstrates how you might use the MongoDB Ruby driver
to locate restaurants in a particular New York neighborhood. It uses
MongoDB's geospatial indexing feature to find documents which match
coordinate criteria (longitude/latitude). The ``neighborhoods.json``
JSON file contains a list of New York neighborhoods and their
locations, while the ``restaurants.json`` JSON file contains a list
of restaurants and their locations.

Prerequisites
-------------

Before using this sample application, make sure you have a ``mongod``
instance (version 3.2 or later) running on ``localhost`` port ``27017``
(the default). 

- MongoDB [installation instructions](https://docs.mongodb.com/manual/installation/)

Make sure that all the files in the ``bin`` directory are executable.

Files to run once
-----------------

- ``import.sh`` imports the ``restaurants.json`` and
  ``neighborhoods.json`` data files into
  collections called ``restaurants`` and ``neighborhoods``
  in the ``test`` database.
  
From the ``bin`` directory:
```
$ ./import.sh
```

- ``setup_collections.rb`` creates several indexes on the two
  collections. In the ``restaurants`` collection it creates:
  - a multikey index on the ``categories`` field
  - a geospatial index on the ``contact.location`` field
 
  It also sets up a validator for the ``restaurants``
  collection which ensures the following:
 
  - the ``name`` field is a string
  - the ``stars`` field is a number
  
  In the ``neighborhoods`` collection it creates:
  - a geospatial index on the ``geometry`` field

```
$ ./setup_collections.rb
```

If you want to start over from scratch, the ``reset.rb`` script drops
both the collections from the database.

```
$ ./reset.rb
```

Find nearby restaurants
-----------------------

You can run ``find_nearby.rb`` to either list all the restaurants in
a specified neighborhood, or list all the neighborhoods which begin
with a specified letter.

From the command prompt in the ``bin`` directory:

```
$ ./find_nearby.rb -l c # returns a list of all neighborhoods starting with 'C'

$ ./find_nearby.rb -n Canarsie # returns a list of all restaurants in the Canarsie neighborhood

$ ./find_nearby.rb -n 'Park Slope-Gowanus' # use quotes around neighborhoods with spaces
```

Create a new restaurant record
------------------------------

To add a new record to the ``restaurants`` collection, use the
``insert_one.rb`` file from the command line and follow the prompts.

```
$ ./insert_one.rb 
```

Count all restaurants in all neighborhoods
------------------------------------------

``location_count.rb`` is an example of a script to assemble results
from two collections. Note that this script is "expensive" (may take
over 5 seconds to run) since it involves a large number of individual
queries.

```
$ ./location_count.rb
```

Unit tests
----------

To run the unit tests for this project, make sure you have
[rspec](https://www.relishapp.com/rspec) installed.

From the project root directory:
```
$ rspec spec/*
```