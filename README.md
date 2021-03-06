# NYT Books API

The _New York Times_ maintains a number of APIs for developers that need a programmatic way to access their content. Among these is the [Books API](http://developer.nytimes.com/books_api.json), which provides access to the best seller lists.

This document describes an R implementation to access it.

## Initiation

First, the user must obtain an NYT developer key. I have stored mine in a private file called `config.R` in the variable `API_KEY`:

```{r}
source('config.R')
```

I "connect" to the API by inputting the key into the `NewYorkTimesBooks` object:

```{r, warning=FALSE, message=FALSE}
source('./R/nyt_books.R')
nyt <- NewYorkTimesBooks(api_key=API_KEY)
```

Note that there is no real _connecting_ going on here. The `NewYorkTimesBooks` object is merely a conveniant way to store two pieces of information required by the rest of the methods: the API key, as well as the API's base URL: `https://api.nytimes.com/svc/books/v3`.



## Bestseller Lists

The paper maintains a number of best seller lists, e.g., hardcover non-fiction. Any user's first step must be to determine which best seller list they are interested in.

This function enumerates these lists:

```{r, warning=FALSE, message=FALSE}
source('./R/bestseller_list_names.R')
bs_list <- bestseller_list_names(nyt)

head(bs_list)
```

Of particular importance is the column `list_name_encoded`. It contains how each list is represented in the API; e.g., the 'Combined Print and E-Book Fiction' is represented as `combined-print-and-e-book-fiction`.



## Retrieving a List

One a user knows the encoding they want to investigate, they can download the list data with the `get_bestseller_list()` function.

Note that this function accepts a number of parameters; the `nyt` object and `list_name` are required. Optional arguments are documented in the function script, including `weeks_on_list`, `isbn`, and others.

Parameters are imputed to the function via a named list:

```{r, warning=FALSE, message=FALSE}
source('./R/get_bestseller_list.R')
p <- list(published_date='2018-10-01')
print_ebook_list <- get_bestseller_list(nyt, 'combined-print-and-e-book-fiction',
                                         parameters=p)

str(print_ebook_list)
```



## Best Seller History of a Book

What if you wanted to retrieve the historical best seller of a particular item or group of items? This is possible with the `get_bestseller_history()` function. Unlike above, it has no required arguments besides the `nyt` object, but it accepts a wide variety of parameters, including `author`, `title`, `publisher`, etc., as documented in the function script.

```{r, warning=FALSE, message=FALSE}
source('./R/get_bestseller_history.R')
p <- list(author='Stephen King')
stephen_king_history <- get_bestseller_history(nyt, parameters=p)

str(stephen_king_history)
```



## Retrieve Best Seller Reviews

Users can retrieve an index of reviews via `get_bestseller_reviews()`. This function requires only the `nyt` object, but accepts a few parameters to help them find a specific work: `isbn`, `title`, or `author`.


```{r, warning=FALSE, message=FALSE}
source('./R/get_bestseller_reviews.R')
p <- list(author='Stephen King', title='11/22/63')
reviews <- get_bestseller_reviews(nyt, parameters=p)

str(reviews)
```