start <- Sys.time()

source("r/get_jsd.R")

message("counting occurrences")
table <- lotus
table_counted <- lotus |> 
  dplyr::select(
    structure_smiles_2D,
    structure_taxonomy_npclassifier_01pathway,
    structure_taxonomy_npclassifier_02superclass,
    structure_taxonomy_npclassifier_03class,
    organism_name,
    organism_taxonomy_ottid,
    organism_taxonomy_01domain,
    organism_taxonomy_02kingdom,
    organism_taxonomy_03phylum,
    organism_taxonomy_04class,
    organism_taxonomy_05order,
    organism_taxonomy_06family,
    organism_taxonomy_07tribe,
    organism_taxonomy_08genus,
    organism_taxonomy_09species,
    organism_taxonomy_10varietas
  ) |>
  dplyr::distinct() |>
  dplyr::group_by(
    structure_taxonomy_npclassifier_01pathway,
    organism_taxonomy_02kingdom
  ) |>
  dplyr::add_count(name = "structure_taxonomy_npclassifier_01pathway_organism_taxonomy_02kingdom") |>
  dplyr::group_by(
    structure_taxonomy_npclassifier_02superclass,
    organism_taxonomy_02kingdom
  ) |>
  dplyr::add_count(name = "structure_taxonomy_npclassifier_02superclass_organism_taxonomy_02kingdom") |>
  dplyr::group_by(
    structure_taxonomy_npclassifier_03class,
    organism_taxonomy_02kingdom
  ) |>
  dplyr::add_count(name = "structure_taxonomy_npclassifier_03class_organism_taxonomy_02kingdom") |>
  dplyr::group_by(
    structure_taxonomy_npclassifier_01pathway,
    organism_taxonomy_06family
  ) |>
  dplyr::add_count(name = "structure_taxonomy_npclassifier_01pathway_organism_taxonomy_06family") |>
  dplyr::group_by(
    structure_taxonomy_npclassifier_02superclass,
    organism_taxonomy_06family
  ) |>
  dplyr::add_count(name = "structure_taxonomy_npclassifier_02superclass_organism_taxonomy_06family") |>
  dplyr::group_by(
    structure_taxonomy_npclassifier_03class,
    organism_taxonomy_06family
  ) |>
  dplyr::add_count(name = "structure_taxonomy_npclassifier_03class_organism_taxonomy_06family") |>
  dplyr::group_by(
    structure_taxonomy_npclassifier_01pathway,
    organism_taxonomy_08genus
  ) |>
  dplyr::add_count(name = "structure_taxonomy_npclassifier_01pathway_organism_taxonomy_08genus") |>
  dplyr::group_by(
    structure_taxonomy_npclassifier_02superclass,
    organism_taxonomy_08genus
  ) |>
  dplyr::add_count(name = "structure_taxonomy_npclassifier_02superclass_organism_taxonomy_08genus") |>
  dplyr::group_by(
    structure_taxonomy_npclassifier_03class,
    organism_taxonomy_08genus
  ) |>
  dplyr::add_count(name = "structure_taxonomy_npclassifier_03class_organism_taxonomy_08genus") |>
  dplyr::ungroup() |>
  dplyr::distinct(
    structure_taxonomy_npclassifier_01pathway,
    structure_taxonomy_npclassifier_02superclass,
    structure_taxonomy_npclassifier_03class,
    organism_taxonomy_02kingdom,
    organism_taxonomy_06family,
    organism_taxonomy_08genus,
    structure_taxonomy_npclassifier_01pathway_organism_taxonomy_02kingdom,
    structure_taxonomy_npclassifier_02superclass_organism_taxonomy_02kingdom,
    structure_taxonomy_npclassifier_03class_organism_taxonomy_02kingdom,
    structure_taxonomy_npclassifier_01pathway_organism_taxonomy_06family,
    structure_taxonomy_npclassifier_02superclass_organism_taxonomy_06family,
    structure_taxonomy_npclassifier_03class_organism_taxonomy_06family,
    structure_taxonomy_npclassifier_01pathway_organism_taxonomy_08genus,
    structure_taxonomy_npclassifier_02superclass_organism_taxonomy_08genus,
    structure_taxonomy_npclassifier_03class_organism_taxonomy_08genus
  ) |>
  dplyr::arrange(
    structure_taxonomy_npclassifier_01pathway,
    structure_taxonomy_npclassifier_02superclass,
    structure_taxonomy_npclassifier_03class
  )

message("computing JSD at the chemical class level ...")
chem_level <- "structure_taxonomy_npclassifier_03class"

message("... at the biological genus level")
bio_level <- "organism_taxonomy_08genus"
Y <-
  unique(table_counted[, chem_level][!is.na(table_counted[, chem_level]) &
                                       !is.na(table_counted[, bio_level])])
X <- seq_along(Y)

class_1 <- invisible(pbmcapply::pbmclapply(
  FUN = get_jsd,
  X = X,
  mc.cores = min(max(1, parallel::detectCores() - 1), 10)
)) |>
  data.table::rbindlist()

message("... at the biological family level")
bio_level <- "organism_taxonomy_06family"
Y <-
  unique(table_counted[, chem_level][!is.na(table_counted[, chem_level]) &
                                       !is.na(table_counted[, bio_level])])
X <- seq_along(Y)

class_2 <- invisible(pbmclapply(
  FUN = get_jsd,
  X = X,
  mc.cores = min(max(1, parallel::detectCores() - 1), 10),
  ignore.interactive = TRUE,
  mc.style = "txt",
  mc.substyle = 1
)) |>
  rbindlist()

message("... at the biological kingdom level")
bio_level <- "organism_taxonomy_02kingdom"
Y <-
  unique(table_counted[, chem_level][!is.na(table_counted[, chem_level]) &
                                       !is.na(table_counted[, bio_level])])
X <- seq_along(Y)

class_3 <- invisible(pbmclapply(
  FUN = get_jsd,
  X = X,
  mc.cores = min(max(1, parallel::detectCores() - 1), 10),
  ignore.interactive = TRUE,
  mc.style = "txt",
  mc.substyle = 1
)) |>
  rbindlist()

class <- class_1 |>
  full_join(class_2) |>
  full_join(class_3) |>
  data.frame()

colnames(class)[grepl(pattern = "organism", x = colnames(class))] <-
  paste(colnames(class)[grepl(pattern = "organism", x = colnames(class))], "JSD", sep = "_")

message("... at the chemical superclass level ...")
chem_level <- "structure_taxonomy_npclassifier_02superclass"

message("... at the biological genus level")
bio_level <- "organism_taxonomy_08genus"
Y <-
  unique(table_counted[, chem_level][!is.na(table_counted[, chem_level]) &
                                       !is.na(table_counted[, bio_level])])
X <- seq_along(Y)

superclass_1 <- invisible(pbmclapply(
  FUN = get_jsd,
  X = X,
  mc.cores = min(max(1, parallel::detectCores() - 1), 10)
)) |>
  rbindlist()

message("... at the biological family level")
bio_level <- "organism_taxonomy_06family"
Y <-
  unique(table_counted[, chem_level][!is.na(table_counted[, chem_level]) &
                                       !is.na(table_counted[, bio_level])])
X <- seq_along(Y)

superclass_2 <- invisible(pbmclapply(
  FUN = get_jsd,
  X = X,
  mc.cores = min(max(1, parallel::detectCores() - 1), 10),
  ignore.interactive = TRUE,
  mc.style = "txt",
  mc.substyle = 1
)) |>
  rbindlist()

message("... at the biological kingdom level")
bio_level <- "organism_taxonomy_02kingdom"
Y <-
  unique(table_counted[, chem_level][!is.na(table_counted[, chem_level]) &
                                       !is.na(table_counted[, bio_level])])
X <- seq_along(Y)

superclass_3 <- invisible(pbmclapply(
  FUN = get_jsd,
  X = X,
  mc.cores = min(max(1, parallel::detectCores() - 1), 10),
  ignore.interactive = TRUE,
  mc.style = "txt",
  mc.substyle = 1
)) |>
  rbindlist()

superclass <- superclass_1 |>
  full_join(superclass_2) |>
  full_join(superclass_3) |>
  data.frame()

colnames(superclass)[grepl(pattern = "organism", x = colnames(superclass))] <-
  paste(colnames(superclass)[grepl(pattern = "organism", x = colnames(superclass))], "JSD", sep = "_")

message("... at the chemical pathway level ...")
chem_level <- "structure_taxonomy_npclassifier_01pathway"

message("... at the biological genus level")
bio_level <- "organism_taxonomy_08genus"
Y <-
  unique(table_counted[, chem_level][!is.na(table_counted[, chem_level]) &
                                       !is.na(table_counted[, bio_level])])
X <- seq_along(Y)

pathway_1 <- invisible(pbmclapply(
  FUN = get_jsd,
  X = X,
  mc.cores = min(max(1, parallel::detectCores() - 1), 10),
  ignore.interactive = TRUE,
  mc.style = "txt",
  mc.substyle = 1
)) |>
  rbindlist()

message("... at the biological family level")
bio_level <- "organism_taxonomy_06family"
Y <-
  unique(table_counted[, chem_level][!is.na(table_counted[, chem_level]) &
                                       !is.na(table_counted[, bio_level])])
X <- seq_along(Y)

pathway_2 <- invisible(pbmclapply(
  FUN = get_jsd,
  X = X,
  mc.cores = min(max(1, parallel::detectCores() - 1), 10),
  ignore.interactive = TRUE,
  mc.style = "txt",
  mc.substyle = 1
)) |>
  rbindlist()

message("... at the biological kingdom level")
bio_level <- "organism_taxonomy_02kingdom"
Y <-
  unique(table_counted[, chem_level][!is.na(table_counted[, chem_level]) &
                                       !is.na(table_counted[, bio_level])])
X <- seq_along(Y)

pathway_3 <- invisible(pbmclapply(
  FUN = get_jsd,
  X = X,
  mc.cores = min(max(1, parallel::detectCores() - 1), 10),
  ignore.interactive = TRUE,
  mc.style = "txt",
  mc.substyle = 1
)) |>
  rbindlist()

pathway <- pathway_1 |>
  full_join(pathway_2) |>
  full_join(pathway_3) |>
  data.frame()

colnames(pathway)[grepl(pattern = "organism", x = colnames(pathway))] <-
  paste(colnames(pathway)[grepl(pattern = "organism", x = colnames(pathway))], "JSD", sep = "_")

message("pivoting results")
class_pivoted <- class |>
  pivot_longer(cols = 2:4, values_to = c("value_score")) |>
  mutate(
    name_structure = "structure_taxonomy_npclassifier_03class",
    value_structure = structure_taxonomy_npclassifier_03class,
    name_score = name
  ) |>
  select(
    name_structure,
    value_structure,
    name_score,
    value_score
  ) |>
  filter(!is.na(value_score))

superclass_pivoted <- superclass |>
  pivot_longer(cols = 2:4, values_to = c("value_score")) |>
  mutate(
    name_structure = "structure_taxonomy_npclassifier_02superclass",
    value_structure = structure_taxonomy_npclassifier_02superclass,
    name_score = name
  ) |>
  select(
    name_structure,
    value_structure,
    name_score,
    value_score
  ) |>
  filter(!is.na(value_score))

pathway_pivoted <- pathway |>
  pivot_longer(cols = 2:4, values_to = c("value_score")) |>
  mutate(
    name_structure = "structure_taxonomy_npclassifier_01pathway",
    value_structure = structure_taxonomy_npclassifier_01pathway,
    name_score = name
  ) |>
  select(
    name_structure,
    value_structure,
    name_score,
    value_score
  ) |>
  filter(!is.na(value_score))

final <- rbind(pathway_pivoted, superclass_pivoted, class_pivoted)

message("exporting")
write_delim(
  x = final,
  file = file.path(pathDataProcessed, "jsd_full.tsv"),
  delim = "\t",
  na = ""
)

write_delim(
  x = class,
  file = file.path(pathDataProcessed, "jsd_class.tsv"),
  delim = "\t",
  na = ""
)

write_delim(
  x = superclass,
  file = file.path(pathDataProcessed, "jsd_superclass.tsv"),
  delim = "\t",
  na = ""
)

write_delim(
  x = pathway,
  file = file.path(pathDataProcessed, "jsd_pathway.tsv"),
  delim = "\t",
  na = ""
)

end <- Sys.time()

message("Script finished in", format(end - start))
