library(data.table)

setwd("/lustre/scratch122/tol/teams/blaxter/users/mb39/plant-sequencing-status/src")

assemblies <- unique(fread("../data/all_assembled_plant_genomes.tsv",
    col.names = c("group", "species", "stage"),
    header = FALSE
))
samples <- unique(fread("../data/all_plant_samples_by_genomic_data.tsv",
    col.names = c("group", "species", "delete", "sample", "type"),
    header = FALSE
))

no_assemblies <- assemblies[, .(.N), by = .(group, stage)]

data_per_species <- unique(
    samples[, -c("delete", "sample")]
)[, .(.N), by = .(type)]

# print github table
cat(r"{# DToL Plant Sequencing Status

Two summary tables are presented here. The first is the number of assemblies in the pipelines at the moment.

| Plant Group | Stage | Number |
| --- | --- | --- |
}")

for (i in seq_len(nrow(no_assemblies))) {
    group <- no_assemblies[i, ]$group
    stage <- no_assemblies[i, ]$stage
    n <- no_assemblies[i, ]$N

    cat(paste(
        "|", group,
        "|", stage,
        "|", n,
        "|\n"
    ))
}

cat(r"{
The second is the number of data types per species.

| Data type | Number |
| --- | --- |
}")

for (i in seq_len(nrow(data_per_species))) {
    type <- data_per_species[i, ]$type
    n <- data_per_species[i, ]$N

    cat(paste(
        "|", type,
        "|", n,
        "|\n"
    ))
}
