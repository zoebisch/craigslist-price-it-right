# Specifications for the CLI Assessment

Specs:
- [x] Have a CLI for interfacing with the application.  
    1)The program begins by prompting the user for the main Craigslist (CL) page and the user selects the category.
    2)The user is then guided to look for a search item.  This can be any string. All results from the category are returned. The user can then perform the following:
      A)view items as-is
      B)view items narrowed by search string (price ascending, I find this the most helpful fashion).
      C)view items narrowed within a price range established by the user.
      D)view advanced item info by unique identifier (pid)
- [X] Pull data from an external source
    1)The program scrapes all categories (within the "for sale" categories on the CL page). Only if the user selects one of the unique categories ["auto parts", "bikes", "boats", "cars+trucks", "computers", "motorcycles"] does the program drill down into the second page level for these categories as well, allowing the user to further select those.
    2)The program scrapes all items from a category, loading each page and scraping them for a collection of all items within a category. These items are then turned into objects. All items are objects and are manipulated as objects.
    3)The program also will drill down to the third level, grabbing all information for a selected unique id (pid). This data is merged with the original second level scraped data automatically.
- [X] Implement both list and detail views
    1) Provides list of items within a category.
    2) Provides list of items with price sorted by ascending price.
    3) Provides a list of detail by scraping a third level page by pid.
