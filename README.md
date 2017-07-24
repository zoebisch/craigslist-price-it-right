# CraigslistPriceItRight

The Price is Right

A CLI to scrape similar sale items from Craigslist to help form a suggested price.

***Use this at your own risk!  Although I have done my best to shield the user from an IP ban from Craigslist, there is no guarantee this will not happen as CL is rather strict on people scraping information from their sites. If this happens, you can appeal to CL (assuming you are not doing anything commercial with this code) and request a removal of the ban. However, I have been successfully using this tool for some time now and have received no further bans***

Future ideas:
    near-term: Identify outliers OR weighted average.
              Advanced analysis and price suggestion.
              Extend search to ALL categories, not just for sale
    wishlist: Classify $1 price (these are sometimes spam or oddball posts)
              Smart search (experiment with advanced search methods)
    crazy wishlist: Make an autopost function!


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'craigslist_price_it_right'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install craigslist_price_it_right

## Usage

Program Flow:
User selects which Craigslist site to use (copy/paste, type. Default is set in code to https://seattle.craigslist.org)
User selects Craigslist category from scraped categories
Program scrapes all potential instances from site
User enters search item:
  1) This does not have a smart search, it only looks for a match to item string the user selects
  2) Items with no price listing will not have price key

Program attempts to form novel price analysis:
  1) Determine low and high pricing.
  2) Determine novel statistics (min, max, mean)
  3) Allow user to specify range and return condensed novel statistics

  main menu is self-explanatory and interactive

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/zoebisch/craigslist_price_it_right.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
