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

genomescope <- fread("../data/genomescope_full.tsv")

# species	tolid	p	k	Homozygous_aa_min	Homozygous_aa_max	Heterozygous_ab_min	Heterozygous_ab_max	Genome_Haploid_Length_min_bp	Genome_Haploid_Length_max_bp	Genome_Repeat_Length_min_bp	Genome_Repeat_Length_max_bp	Genome_Unique_Length_min_bp	Genome_Unique_Length_max_bp	Model_Fit_min_percent	Model_Fit_max_percent	Read_Error_Rate_min_percent	Read_Error_Rate_max_percent

# setnames(x = genomescope, old = c("V1", "V2", "V3"), new = c("species", "tolid", "pacbio_genomescope_length"))

genomescope[, species := gsub(x = species, pattern = "_", replacement = " ")]

# merge the data

all_estimates <- unique(merge(assemblies, genomescope, by = c("species"), all.x = TRUE))

fwrite(all_estimates, file = "../data/merged_genome_size_estimates.tsv", sep = "\t")

# add the c value data

cval <- fread("../data/dtol_cval_database_26_08_25.csv")

# if the 1C/Gbp value is missing, delete the row
cval <- cval[!is.na(`1C/Gbp`)]

# in the 'Project' column, we want only DTOL
cval <- cval[Project == "DTOL"]

# rename V1 to collection location
setnames(cval, old = "V1", new = "collection_location")

# create a new column 'species' that combines 'Genus' and 'Species'
cval[, species := paste(Genus, Species, sep = " ")]

# where there are multiple species with the same name
# choose the one with the latest date in the 'Date' column
# where Date is in the format 03/08/21 (dd/mm/yy)

cval[, Date := as.Date(Date, format = "%d/%m/%y")]
cval <- cval[order(species, -Date)]
cval <- cval[!duplicated(species)]

# remove '-' from species names in gs
cval[, species := gsub("-", " ", species)]
cval[, species := gsub(" - ", " ", species)]
# remove extra spaces from species names
cval[, species := gsub("\\s+", " ", species)]

# change species name Gnaphalium uliginosa to Gnaphalium uliginosum
cval[species == "Gnaphalium uliginosa", species := "Gnaphalium uliginosum"]
cval[species == "Teucrium scordonia", species := "Teucrium scorodonia"]

# merge with genome size estimates from genomescope
merged <- merge(all_estimates, cval, by = "species", all.x = TRUE)

# about 30 species did not merge, no data?? I fixed a couple of obvious
# taxonomic issues above
# unique(merged[is.na(`1C/Gbp`)]$species)

fwrite(merged, file = "../data/all_genome_size_data.tsv", sep = "\t")
