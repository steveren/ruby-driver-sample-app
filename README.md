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
instance running on the default port ``27017``.

Make sure that all the program files (``import.sh`` and all the ``.rb``
files) are executable.

Files to run once
-----------------

- ``import.sh`` imports the ``restaurants.json`` and
  ``neighborhoods.json`` data files into
  collections called ``restaurants`` and ``neighborhoods``
  in the ``test`` database.
  
```
$ ./import.sh
```

- ``setup_collection.rb`` creates several indexes on the two
  collections. In the ``restaurants`` collection it creates:
  - a multikey index on the ``categories`` field
  - a geospatial index on the ``contact.location`` field
 
  It also sets up a validator for the ``restaurants``
  collection which ensures the following:
 
  - the ``name`` field is a string
  - the ``stars`` field is a number
  
  In the ``neighborhoods`` collection it creates:
  - a geospatial index on the ``geometry`` field

If you want to start over from scratch, the ``reset.rb`` script drops
both the collections from the database.

Find nearby restaurants
-----------------------

You can run ``find_nearby.rb`` to either list all the restaurants in
a specified neighborhood, or list all the neighborhoods which begin
with a specified letter.

From the command prompt:

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
