#!/usr/bin/env bash
out=../data/genomescope_full.tsv

# header
printf "%s\n" \
"species	tolid	p	k	Homozygous_aa_min	Homozygous_aa_max	Heterozygous_ab_min	Heterozygous_ab_max	Genome_Haploid_Length_min_bp	Genome_Haploid_Length_max_bp	Genome_Repeat_Length_min_bp	Genome_Repeat_Length_max_bp	Genome_Unique_Length_min_bp	Genome_Unique_Length_max_bp	Model_Fit_min_percent	Model_Fit_max_percent	Read_Error_Rate_min_percent	Read_Error_Rate_max_percent" \
> "$out"

for file in /data/tol/data/darwin/{dicots,monocots,vascular-plants,non-vascular-plants}/*/genomic_data/*/pacbio/kmer/*/fastk_genomescope_summary.txt; do
  nm=$(echo "$file" | cut -d/ -f7)
  tolid=$(echo "$file" | cut -d/ -f9)

  awk -v nm="$nm" -v tolid="$tolid" -v OFS='\t' '
    BEGIN{
      CONVFMT="%.17g"; OFMT="%.17g";
      p=""; k="";
      props["Homozygous (aa)"]="Homozygous_aa";
      props["Heterozygous (ab)"]="Heterozygous_ab";
      props["Genome Haploid Length"]="Genome_Haploid_Length";
      props["Genome Repeat Length"]="Genome_Repeat_Length";
      props["Genome Unique Length"]="Genome_Unique_Length";
      props["Model Fit"]="Model_Fit";
      props["Read Error Rate"]="Read_Error_Rate";
      for (k2 in props){ vals[props[k2] "_min"]="NA"; vals[props[k2] "_max"]="NA"; }
    }

    function ltrim(s){ sub(/^[[:space:]]+/,"",s); return s }
    function rtrim(s){ sub(/[[:space:]]+$/,"",s); return s }
    function clean(x){
      gsub(/,/,"",x);
      if (x ~ /^NA([[:space:]]|$)/) return "NA";
      sub(/[[:space:]]*bp$/,"",x);
      sub(/%$/,"",x);
      return x
    }

    # pop the rightmost value (ends with "bp" or "%") from global R
    function pop_val(   m,val){
      R=rtrim(R);
      if (match(R, /((NA|[0-9][0-9,\.]*)([[:space:]]*bp|%))[[:space:]]*$/, m)) {
        val=m[1];
        R=substr(R,1,RSTART-1);  # remove matched tail
        return clean(val);
      }
      return "NA";
    }

    # p and k
    /^[[:space:]]*p[[:space:]]*=/ { if (match($0,/=[[:space:]]*([0-9]+)/,m)) p=m[1]; next }
    /^[[:space:]]*k[[:space:]]*=/ { if (match($0,/=[[:space:]]*([0-9]+)/,m)) k=m[1]; next }

    # property rows (allow leading spaces)
    /^[[:space:]]*(Homozygous \(aa\)|Heterozygous \(ab\)|Genome Haploid Length|Genome Repeat Length|Genome Unique Length|Model Fit|Read Error Rate)/ {
      L = rtrim(ltrim($0));

      # split into prop and remainder at the first run of 2+ spaces
      if (match(L, /[[:space:]]{2,}/)) {
        prop = substr(L, 1, RSTART-1);
        R    = substr(L, RSTART+RLENGTH);
        R    = rtrim(R);

        maxv = pop_val();   # rightmost = max
        minv = pop_val();   # next = min

        key = props[prop];
        if (key!="") { vals[key "_min"]=minv; vals[key "_max"]=maxv; }
      }
      next
    }

    END{
      printf "%s\t%s\t%s\t%s", nm, tolid, p, k;
      printf "\t%s\t%s", vals["Homozygous_aa_min"],        vals["Homozygous_aa_max"];
      printf "\t%s\t%s", vals["Heterozygous_ab_min"],      vals["Heterozygous_ab_max"];
      printf "\t%s\t%s", vals["Genome_Haploid_Length_min"], vals["Genome_Haploid_Length_max"];
      printf "\t%s\t%s", vals["Genome_Repeat_Length_min"],  vals["Genome_Repeat_Length_max"];
      printf "\t%s\t%s", vals["Genome_Unique_Length_min"],  vals["Genome_Unique_Length_max"];
      printf "\t%s\t%s", vals["Model_Fit_min"],            vals["Model_Fit_max"];
      printf "\t%s\t%s", vals["Read_Error_Rate_min"],      vals["Read_Error_Rate_max"];
      printf "\n"; }
      ' "$file" >> "$out"
done
