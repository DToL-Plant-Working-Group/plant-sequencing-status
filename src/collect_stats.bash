#!/usr/bin/env bash

printf "Begin fetching plant names\n"

# Assemblies
printf "Fetching assemblies\n"

/bin/ls -thor /data/tol/data/darwin/{dicots,monocots,vascular-plants,non-vascular-plants}/*/assembly/release/*/insdc/ | \
  grep "/data" | \
  awk -F/ '{print $6,"\t",$7,"\t","released"}' | \
  sort | \
  uniq > all_assembled_plant_genomes.tsv

/bin/ls -thor /data/tol/data/darwin/{dicots,monocots,vascular-plants,non-vascular-plants}/*/assembly/curated/* | \
  grep "/data/tol" | \
  awk -F/ '{print $6, "\t", $7, "\t", "curated"}' | \
  sort | \
  uniq >> all_assembled_plant_genomes.tsv

/bin/ls -thor /data/tol/data/darwin/{dicots,monocots,vascular-plants,non-vascular-plants}/*/assembly/draft/* | \
  grep "/data/tol" | \
  awk -F/ '{print $6, "\t", $7, "\t", "draft"}' | \
  sort | \
  uniq >> all_assembled_plant_genomes.tsv

printf "Fetching genomic data\n"

# Genomic data
/bin/ls -thor /data/tol/data/darwin/{dicots,monocots,vascular-plants,non-vascular-plants}/*/genomic_data/*/* | \
  grep "/data/tol" | \
  awk -F/ '{print $6,"\t",$7,"\t",$8,"\t",$9,"\t",$10}' | \
  sort | \
  uniq | \
  sed 's/:$//' > all_plant_samples_by_genomic_data.tsv

printf "Done\n"

mv all_assembled_plant_genomes.tsv ../data/
mv all_plant_samples_by_genomic_data.tsv ../data/
