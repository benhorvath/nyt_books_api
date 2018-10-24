
# Create a file called config.R with a string variable called API_KEY
source('config.R')

source('./R/nyt_books.R')
nyt <- NewYorkTimesBooks(api_key=API_KEY)

source('./R/bestseller_list_names.R')
bslist <- bestseller_list_names(nyt)

source('./R/get_bestseller_list.R')
p <- list(published_date='2018-10-01')
r <- get_bestseller_list(nyt, 'combined-print-and-e-book-fiction', parameters=p)

source('./R/get_bestseller_history.R')
p <- list(author='Stephen King')
h <- get_bestseller_history(nyt, parameters=p)

source('./R/get_bestseller_reviews.R')
p <- list(author='Stephen King', title='11/22/63')
r <- get_bestseller_reviews(nyt, parameters=p)





### PARAMS ###




#
# /lists/overview.{format}
#    Best Seller List Overview
#    Parameters:
#        @api-key
#        @published_date: YYYY-MM-DD
#

#
# /reviews.{format}
#    Reviews
#    Parameters:
#        @api-key
#        @isbn: 10 or 13-digit int
#        @title: str
#        @author: first and last name seperated by space
#        
 
# LIST
# https://api.nytimes.com/svc/books/v3/lists/names.json?api-key=70651c908389427f93df5cc9ed3d1665&page=0

base_url <- 'https://api.nytimes.com/svc/books/v3/lists/names.json'

query <- paste('api-key', API_KEY, sep='=')
request_url <- paste(base_url, query, sep='?')

response <- getURL(request_url)

df <- fromJSON(response, flatten=TRUE)$results

####

library(urltools)

base_url %>%
param_set(key = "api-key", value = API_KEY) %>%
param_set(key='sort', value='ASC')


####

# Let's create a function that stores base URL, and uses ...
# to create a query string out of those additional parameters

append_params <- function(base_url, parameters) {
    for (i in 1:length(parameters)) {
        key_name <- names(parameters)[i]
        key_val <- parameters[[key_name]]
        base_url <- param_set(base_url, key=key_name, value=key_val)
    }
    return(base_url)
}

base_url <- 'https://api.nytimes.com/svc/books/v3/lists/names.json'
params <- list(`sort`=c('ASC'), `api-key`=c(API_KEY))

append_params(base_url, params)

