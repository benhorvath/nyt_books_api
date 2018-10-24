library(jsonlite)
library(RCurl)
library(urltools)

# Returns a list of the different best sellers lists the NEw York Times
# maintains, e.g., Hardcover Nonfiction.
bestseller_list_names <- function(nyt) {
    base_url <- paste(nyt@base_url, 'lists/names.json', sep='/')
    request_url <- param_set(base_url, key='api-key', value=nyt@api_key)
    response <- getURL(request_url)
    df <- fromJSON(response, flatten=TRUE)$results
    return(df)
}