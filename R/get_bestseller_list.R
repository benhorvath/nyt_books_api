library(dplyr)
library(jsonlite)
library(RCurl)
library(urltools)

source('utils.R')

# Returns a given best seller list, named by the user. parameters is a named
# list allowing users to submit queries.
#
# Possible parameters:
#     @list: encoded NYT list name (required)
#     @weeks_on_list: int
#     @bestsellers_date: str (YYYY-MM-DD)
#     @date: str (YYYY-MM-DD)
#     @isbn: int, 10 or 13 digits
#     @published_date: str (YYYY-MM-DD)
#     @rank: int
#     @rank_last_week: int
#     @offset: int, pagination
#     @sort_order: str, ASC or DESC
#     
get_bestseller_list <- function(nyt, list_name, parameters=NA) {
    
    base_url <- paste(nyt@base_url, 'lists.json', sep='/')
    request_url <- param_set(base_url, key='api-key', value=nyt@api_key) %>%
        param_set(key='list', value=list_name)
    
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
        # book description
        mutate(book_title = extract_list_vector_attr(book_details, 'title'),
               book_desc = extract_list_vector_attr(book_details, 'description'),
               author = extract_list_vector_attr(book_details, 'author'),
               contributor = extract_list_vector_attr(book_details, 'contributor'),
               contributor_note = extract_list_vector_attr(book_details, 'contributor_note'),
               price = extract_list_vector_attr(book_details, 'price'),
               age_group = extract_list_vector_attr(book_details, 'age_group'),
               publisher = extract_list_vector_attr(book_details, 'publisher'),
               primary_isbn13 = extract_list_vector_attr(book_details, 'primary_isbn13'),
               primary_isbn10 = extract_list_vector_attr(book_details, 'primary_isbn10')) %>%
        # reviews
        mutate(book_review_link = extract_list_vector_attr(reviews, 'book_review_link'),
               first_chapter_link = extract_list_vector_attr(reviews, 'first_chapter_link'),
               sunday_review_link = extract_list_vector_attr(reviews, 'sunday_review_link'),
               article_chapter_link = extract_list_vector_attr(reviews, 'article_chapter_link')) %>%
        select(-c(isbns, book_details, reviews))
    
    return(df)
}