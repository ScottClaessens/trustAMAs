# load country networks
load_country_network <- function(file, log = FALSE) {
  # load distance matrix
  out <- 
    read_excel(file, na = "") %>%
    dplyr::select(-ISO) %>%
    as.matrix()
  rownames(out) <- colnames(out)
  # log distances?
  if (log) out <- log(out)
  # scale distances between 0 and 1
  out <- out / max(out)
  diag(out) <- 0
  # convert to proximity (covariance) matrix
  out <- 1 - out
  # retain countries in this study
  iso_codes <- c("BR", "CL", "CN", "FR", "DE", "IN",
                 "MX", "PL", "ZA", "TR", "GB", "US")
  out[iso_codes, iso_codes]
}
