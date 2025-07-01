#!/usr/bin/env bash

DATE=$(date)

bash collect_stats.bash

# format data
/software/R-4.4.0/exec/bin/Rscript format.R > ../README.md

# git add ..
# git commit -m "Update on: ${DATE}"
# git push
