for spp in /data/tol/data/darwin/{dicots,monocots,vascular-plants,non-vascular-plants}/*/assembly/release/*/insdc/*.json; do
  lvl=$(cat $spp | jq ".assembly_info.assembly_level");
  nm=$(cat $spp | jq ".assembly_info.biosample.description.organism.organism_name");
  anm=$(cat $spp | jq ".assembly_info.assembly_name");
  len=$(cat $spp | jq ".assembly_stats.total_sequence_length");
  uglen=$(cat $spp | jq ".assembly_stats.total_ungapped_length");
  printf "${nm}\t${anm}\t${lvl}\t${len}\t${uglen}\n";
done > ../data/genome_size_assemblies.tsv
