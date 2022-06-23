start <- Sys.time()

# path <-
#   "https://zenodo.org/record/5794107/files/211220_frozen_metadata.csv.gz"
path <-
  "inst/extdata/211220_frozen_metadata.csv.gz"
message("Loading the LOTUS")
lotus <- readr::read_csv(file = path) |>
  dplyr::mutate(structure_inchikey_2D = substring(
    text = structure_inchikey,
    first = 1,
    last = 14
  ))

end <- Sys.time()

message("Lotus loaded in ", format(end - start))
