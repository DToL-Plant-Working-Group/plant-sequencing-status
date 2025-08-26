#!/usr/bin/env bash
out=../data/genomescope_full.tsv

# header
printf "%s\n" \
"species	tolid	p	k	Homozygous_aa_min	Homozygous_aa_max	Heterozygous_ab_min	Heterozygous_ab_max	Genome_Haploid_Length_min_bp	Genome_Haploid_Length_max_bp	Genome_Repeat_Length_min_bp	Genome_Repeat_Length_max_bp	Genome_Unique_Length_min_bp	Genome_Unique_Length_max_bp	Model_Fit_min_percent	Model_Fit_max_percent	Read_Error_Rate_min_percent	Read_Error_Rate_max_percent" \
> "$out"

for file in /data/tol/data/darwin/{dicots,monocots,vascular-plants,non-vascular-plants}/*/genomic_data/*/pacbio/kmer/*/fastk_genomescope_summary.txt; do
  nm=$(echo "$file" | cut -d/ -f7)
  tolid=$(echo "$file" | cut -d/ -f9)

  awk -v nm="$nm" -v tolid="$tolid" -v OFS='\t' -F '[[:space:]]{2,}' '
    BEGIN{
      p=""; k="";
      # map the exact GenomeScope property labels to tidy keys
      props["Homozygous (aa)"]="Homozygous_aa";
      props["Heterozygous (ab)"]="Heterozygous_ab";
      props["Genome Haploid Length"]="Genome_Haploid_Length";
      props["Genome Repeat Length"]="Genome_Repeat_Length";
      props["Genome Unique Length"]="Genome_Unique_Length";
      props["Model Fit"]="Model_Fit";
      props["Read Error Rate"]="Read_Error_Rate";

      # defaults
      for (k2 in props){vals[props[k2] "_min"]="NA"; vals[props[k2] "_max"]="NA";}
    }
    function clean(x,  y){
      y=x;
      gsub(/,/,"",y);
      if (y ~ /^NA/) return "NA";
      gsub(/%/,"",y);
      sub(/[[:space:]]*bp$/,"",y);
      return y;
    }

    # p and k lines (don’t rely on FS)
    /^p[[:space:]]*=/ { if (match($0,/=[[:space:]]*([0-9]+)/,m)) p=m[1]; next }
    /^k[[:space:]]*=/ { if (match($0,/=[[:space:]]*([0-9]+)/,m)) k=m[1]; next }

    # rows in the min/max table (FS = 2+ spaces => $1=property, $2=min, $3=max)
    ($1 in props) {
      vals[props[$1] "_min"]=clean($2);
      vals[props[$1] "_max"]=clean($3);
      next
    }

    END{
      printf "%s\t%s\t%s\t%s", nm, tolid, p, k;
      printf "\t%s\t%s", vals["Homozygous_aa_min"], vals["Homozygous_aa_max"];
      printf "\t%s\t%s", vals["Heterozygous_ab_min"], vals["Heterozygous_ab_max"];
      printf "\t%s\t%s", vals["Genome_Haploid_Length_min"], vals["Genome_Haploid_Length_max"];
      printf "\t%s\t%s", vals["Genome_Repeat_Length_min"], vals["Genome_Repeat_Length_max"];
      printf "\t%s\t%s", vals["Genome_Unique_Length_min"], vals["Genome_Unique_Length_max"];
      printf "\t%s\t%s", vals["Model_Fit_min"], vals["Model_Fit_max"];
      printf "\t%s\t%s", vals["Read_Error_Rate_min"], vals["Read_Error_Rate_max"];
      printf "\n";
    }
  ' "$file" >> "$out"
done

