library(urltools)

# Extracts the attribute of a vector of named lists
extract_list_vector_attr <- function(x, attr) {
    sapply(x, function(y) y[attr][[1]])
}

# Accepts a named list of parameters and appends them to a URL as parameters
# in the appropriate HTTP format 
append_params <- function(base_url, parameters) {
    for (i in 1:length(parameters)) {
        key_name <- names(parameters)[i]
        key_val <- parameters[[key_name]]
        base_url <- param_set(base_url, key=key_name, value=key_val)
    }
    return(base_url)
}
