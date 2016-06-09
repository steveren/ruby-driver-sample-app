#!/bin/sh
# Import sample datasets into MongoDB

`mongoimport --db test --collection restaurants --file restaurants.json`

`mongoimport --db test --collection neighborhoods --file neighborhoods.json`