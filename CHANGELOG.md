# Changelog

## [Unreleased]

## [0.2.1] - 2024-12-29

- Fixed typo in `minWear` and `maxWear`

## [0.2.0] - 2024-12-26

- Added support for querying multiple items in one request
- By setting `pages` to -1, ALL available results are fetched instead of default 50
- Added search options:
  - `pages`: Number of pages to fetch
  - `request_delay`: Delay in seconds between requests (when multiple pages are requested)
  - `min_price`: Minimum price to filter results by
  - `max_price`: Maximum price to filter results by
  - `min_wear`: Minimum wear to filter results by (0.00 to 1.00)
  - `max_wear`: Maximum wear to filter results by (0.00 to 1.00)
  - `stattrak`: Boolean to filter results by stattrak (Omit -> all, true -> only StatTrak, false -> only non-StatTrak)
  - `souvenir`: Boolean to filter results by souvenir (Omit -> all, true -> only Souvenir, false -> only non-Souvenir)
  - `stackable`: Boolean to filter results by stackable (Omit -> all, true -> only Stackable, false -> only non-Stackable)
  - `tradelocked`: Boolean to filter results by trade-lock (Omit -> all, true -> only Trade-Locked, false -> only non-Trade-Locked)
  - `items_per_page`: Number of items per page (Default is 50 which is also the max)
  - `after_saleid`: ID to start the search after a specific sale
- Documented debug mode in README

## [0.1.0] - 2024-12-25

- Initial release with basic SkinBaron API functionality:
  - Implemented endpoints:
    - `search`: Get CS2 items from the marketplace
  - Error handling for API responses
  - Request/Response logging
  - Support for CS2 (appid: 730)
