# load each data set.

library(data.table)

assemblies <- fread("../data/genome_size_assemblies.tsv")

setnames(x = assemblies, old = c("V1", "V2", "V3", "V4", "V5"), new = c("species", "assembly", "level", "assembly_length", "assembly_ungapped_length"))

assemblies[, species := gsub(x = species, pattern = "-", replacement = " ")]

# sort out some taxonomy issues...
assemblies[species == "Ailanthus altissimus"]$species <- "Ailanthus altissima"
assemblies[species == "Argentina anserina"]$species <- "Potentilla anserina"
assemblies[species == "Lophiolepis eriophora"]$species <- "Cirsium eriophorum"
assemblies[species == "Lysimachia maritima"]$species <- "Glaux maritima"
assemblies[species == "Omalotheca supina"]$species <- "Gnaphalium supinum"
assemblies[species == "Pseudisothecium myosuroides"]$species <- "Isothecium myosuroides"
assemblies[species == "Trocdaris verticillata"]$species <- "Trocdaris verticillatum"

genomescope <- fread("../data/genome_size_genomescope.tsv")

setnames(x = genomescope, old = c("V1", "V2", "V3"), new = c("species", "tolid", "pacbio_genomescope_length"))

genomescope[, species := gsub(x = species, pattern = "_", replacement = " ")]

# merge the data

all_estimates <- unique(merge(assemblies, genomescope, by = c("species"), all.x = TRUE))

fwrite(all_estimates, file = "../data/merged_genome_size_estimates.tsv", sep = "\t")
