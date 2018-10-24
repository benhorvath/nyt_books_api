NewYorkTimesBooks <- setClass(
    'NewYorkTimesBooks',
    slots = c(
        base_url = 'character',
        api_key = 'character'
    ),
    prototype=list(
        base_url = 'https://api.nytimes.com/svc/books/v3'
    )
)