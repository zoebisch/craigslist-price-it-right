The Price is Right

A CLI to scrape similar sale items from Craigslist to form an accurate pricing.

Program Flow:
User adds vanilla item description and Sell timeframe (realistically CL only has 7 days, but in reality most relist)
User selects Craigslist category from scraped categories (to start, this can be extended to ALL categories in the future)
Program scrapes all potential instances from site
  1) Rules must be used -- misspelled, mixed items,
Program attempts to form price analysis:
  1) Determine reasonable low and high pricing.
  2) Classify $1 and no price data to pool - while these have no price, they still have value as data to show market.
  3) Outliers must be filtered based on proximity to compiled list.
    a) Recompile pricing once list has been filtered once
    b) Refine price data 
  4) Program returns price based on data and user Sell timeframe and data to justify this listing.

Extensions/Future:
  Crazy wishlist : Make an autopost function!
