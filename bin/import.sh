#!/bin/sh
# Import sample datasets into MongoDB

`mongoimport --db test --collection restaurants --file ../data/restaurants.json`

`mongoimport --db test --collection neighborhoods --file ../data/neighborhoods.json`