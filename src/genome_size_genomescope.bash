for file in /data/tol/data/darwin/{dicots,monocots,vascular-plants,non-vascular-plants}/*/genomic_data/*/pacbio/kmer/*/fastk_genomescope_summary.txt; do
  bp=$(grep "Genome Haploid Length" $file | \
    awk -F"[[:space:]]{2,}" '{print $3}' | \
    tr -d ',' | cut -d' ' -f1);
  nm=$(echo $file | cut -d/ -f7);
  tolid=$(echo $file | cut -d/ -f9);
  echo -e "${nm}\t${tolid}\t${bp}";
done > ../data/genome_size_genomescope.tsv
