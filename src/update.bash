#!/usr/bin/env bash
set -euo pipefail

# Always run relative to this script's own directory (src/), so it behaves
# the same whether invoked by hand or from cron/LSF with an arbitrary cwd.
cd "$(dirname "${BASH_SOURCE[0]}")"

RSCRIPT=/software/R-4.4.0/exec/bin/Rscript

LOG_DIR=../logs
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/update_$(date +%Y%m%d_%H%M%S).log"
exec > >(tee -a "$LOG_FILE") 2>&1

echo "=== Update started: $(date) ==="

echo "--- Fetching assembly / genomic-data listings ---"
bash collect_stats.bash

echo "--- Fetching genome size data ---"
bash genome_size_assemblies.bash
bash genome_size_genomescope_all.bash

echo "--- Formatting tables ---"
"$RSCRIPT" format_genome_sizes.R
"$RSCRIPT" format.R > ../README.md

echo "--- Refreshing GitHub Pages data ---"
mkdir -p ../docs/data
cp ../data/all_genome_size_data.tsv ../docs/data/all_genome_size_data.tsv

cd ..

TRACKED_OUTPUTS=(
    README.md
    data/all_assembled_plant_genomes.tsv
    data/all_plant_samples_by_genomic_data.tsv
    data/genome_size_assemblies.tsv
    data/genomescope_full.tsv
    data/merged_genome_size_estimates.tsv
    data/all_genome_size_data.tsv
    docs/data/all_genome_size_data.tsv
)

if [[ -n "$(git status --porcelain -- "${TRACKED_OUTPUTS[@]}")" ]]; then
    git add "${TRACKED_OUTPUTS[@]}"
    git commit -m "Automated update: $(date +%d.%m.%y)"
    echo "Committed changes locally. Review with 'git show' and push manually: git push"
else
    echo "No changes to commit."
fi

echo "=== Update finished: $(date) ==="
