#!/usr/bin/env bash

printf "Begin fetching plant names\n"

# Assemblies
printf "Fetching assemblies\n"

ls /lustre/scratch124/tol/projects/darwin/data/{dicots,monocots,vascular-plants,non-vascular-plants}/*/assembly/release/reference 2>/dev/null | \
grep "lustre" | \
awk -F/ '{print $8,"\t",$9,"\t","released"}' | uniq > all_assembled_plant_genomes.tsv

ls /lustre/scratch124/tol/projects/darwin/data/{dicots,monocots,vascular-plants,non-vascular-plants}/*/assembly/curated/* 2>/dev/null | \
grep "lustre" | \
awk -F/ '{print $8,"\t",$9,"\t","curated"}' | uniq >> all_assembled_plant_genomes.tsv

ls /lustre/scratch124/tol/projects/darwin/data/{dicots,monocots,vascular-plants,non-vascular-plants}/*/assembly/draft/* 2>/dev/null | \
grep "lustre" | \
awk -F/ '{print $8,"\t",$9,"\t","draft"}' | uniq >> all_assembled_plant_genomes.tsv

printf "Fetching genomic data\n"

# Genomic data
ls /lustre/scratch124/tol/projects/darwin/data/{dicots,monocots,vascular-plants,non-vascular-plants}/*/genomic_data/*/*/ | \
grep "lustre" | \
awk -F/ '{print $8,"\t",$9,"\t",$10,"\t",$11,"\t",$12}' | uniq > all_plant_samples_by_genomic_data.tsv

printf "Done\n"

mv all_assembled_plant_genomes.tsv ../data/
mv all_plant_samples_by_genomic_data.tsv ../data/
