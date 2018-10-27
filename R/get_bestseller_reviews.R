library(dplyr)
library(jsonlite)
library(RCurl)
library(urltools)

source('./R/utils.R')

# Returns a given best selling book's reviews
#
# Possible parameters:
#     @isbn: int, 10 or 13 digits
#     @title: str
#     @author: str
#     
get_bestseller_reviews <- function(nyt, parameters=NA) {
    
    base_url <- paste(nyt@base_url, 'reviews.json', sep='/')
    request_url <- param_set(base_url, key='api-key', value=nyt@api_key)
    
    if (length(parameters) > 0) {
        # API uses hyphens rather than underscores
        names(parameters) <- gsub('_', '-', names(parameters))
        encoded_parameters <- lapply(parameters, function(x) url_encode(x))
        request_url <- append_params(request_url, encoded_parameters)
    }
    
    response <- getURL(request_url)
    response_parsed <- fromJSON(response)
    status <- response_parsed$status
    num_results <- response_parsed$num_results
    
    if (status != 'OK') {
        stop(paste('API Error:', status))
    } else if (num_results == 0) {
        stop('API returned 0 records')
    }
    
    df <- fromJSON(response, flatten=TRUE)$result %>%
        select(-c(uuid, uri))
    
    return(df)
}