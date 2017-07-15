The Price is Right

A CLI to scrape similar sale items from Craigslist to help form a suggested price.

Program Flow:
User selects which Craigslist site to use
User selects Craigslist category from scraped categories (to start, this could be extended to ALL categories in the future)
Program scrapes all potential instances from site
  1) This does not have a smart search, it only looks for a match to item string the user selects
  2) Items with no price listing will not have price key
Program attempts to form novel price analysis:
  1) Determine reasonable low and high pricing.
  2) Outliers must be filtered based on proximity to compiled list.
    a) Recompile pricing once list has been filtered once
    b) Refine price data 
  3) Program returns price based on data

Future ideas:
    wishlist: Classify $1 price (these are sometimes spam or oddball posts)
              Smart search (experiment with advanced search methods)
    crazy wishlist: Make an autopost function!
