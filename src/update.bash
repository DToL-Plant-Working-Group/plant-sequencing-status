#!/usr/bin/env bash

# fetch new data
bash fetch_stats.bash

# format data

Rscript format.R > ../README.md