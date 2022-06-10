#!/usr/bin/env bash

bash collect_stats.bash

# format data
/software/R-4.1.3/bin/Rscript format.R > ../README.md
