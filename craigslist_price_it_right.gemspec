# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'craigslist_price_it_right/version'

Gem::Specification.new do |spec|
  spec.name          = "craigslist_price_it_right"
  spec.version       = CraigslistPriceItRight::VERSION
  spec.authors       = ["zoebisch"]
  spec.email         = ["zoebisch@gmail.com"]

  spec.summary       = "Craigslist scraper program for helping to price an item for sale"
  spec.description   = "Program sets up menu from scraped for-sale items, allows user to select a category, drills into second level data and self constructs sub-menu, allows user to search for a for-sale item, returns list of items, can sort by price, sort by price range, third level scraping and auto-object-merge based on CL pid"
  spec.homepage      = "https://github.com/zoebisch/craigslist-price-it-right"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata['allowed_push_host'] = "TODO: add url for private host"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against " \
  #     "public gem pushes."
  # end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "nokogiri", "~> 1.8"

end
