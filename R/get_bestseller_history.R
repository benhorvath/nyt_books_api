library(dplyr)
library(jsonlite)
library(RCurl)
library(urltools)

source('./R/utils.R')

# Allows users to query the bestseller list history specific books by
# parameters such as author and title.
#
# Possible parameters:
#     @age_group: int
#     @author: str, Firstname Lastname
#     @contributor: str
#     @isbn: int, 10 or 13 digits
#     @price: float (include decimal)
#     @publisher: str
#     @title: str
     
get_bestseller_history <- function(nyt, parameters=NA) {
    
    base_url <- paste(nyt@base_url, 'lists/best-sellers/history.json', sep='/')
    request_url <- param_set(base_url, key='api-key', value=nyt@api_key)
    
    if (!is.na(parameters)) {
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
        # ISBNs
        mutate(isbn10s = extract_list_vector_attr(isbns, 'isbn10'),
               isbn13s = extract_list_vector_attr(isbns, 'isbn13')) %>%
        # reviews
        mutate(book_review_link = extract_list_vector_attr(reviews, 'book_review_link'),
               first_chapter_link = extract_list_vector_attr(reviews, 'first_chapter_link'),
               sunday_review_link = extract_list_vector_attr(reviews, 'sunday_review_link'),
               article_chapter_link = extract_list_vector_attr(reviews, 'article_chapter_link')) %>%
        select(-c(isbns, reviews))
    
    return(df)
}
