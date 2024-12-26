# SkinBaron API Client

A Ruby gem for interacting with the SkinBaron API. This client provides a simple and intuitive way to access SkinBaron's marketplace functionality for CS2 (Counter-Strike 2) items.

## Quick Start

Install the gem from the command line:

```bash
gem install skinbaron_api_client
```

Then in your Ruby code:

```ruby
require 'skinbaron_api_client'

skinbaron = SkinbaronApiClient::Client.new(api_key: "YOUR_API_KEY")
results = skinbaron.search(items: "AK-47 | Redline")

puts results
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'skinbaron_api_client'
```

And then execute:

```bash
bundle install
```

Or install it yourself as:

```bash
gem install skinbaron_api_client
```

## Usage

First, require the gem:

```ruby
require 'skinbaron_api_client'
```

Initialize the client with your API key. You can do this in two ways:

```ruby
# Method 1: Using a block
skinbaron = SkinbaronApiClient::Client.new do |client|
  client.api_key = "your_api_key"

  client.log_path = "path/to/logs"           # Optional: Path to store ALL logs (2 log files)
  client.request_log_path = "requests.log"   # Optional: Use instead of log_path
  client.error_log_path = "errors.log"       # Optional: Use instead of log_path
  client.appid = 730                         # Optional - defaults to CS2
end

# Method 2: Using keyword arguments
skinbaron = SkinbaronApiClient::Client.new(
  api_key: "your_api_key",

  log_path: "path/to/logs",          # Optional: Base path for logs
  request_log_path: "requests.log",  # Optional: Specific path for request logs
  error_log_path: "errors.log",      # Optional: Specific path for error logs
  appid: 730                         # Optional: appid - already set to CS2 by default
)
```

### Search Items -> `Hash[]`

Search for items on the SkinBaron marketplace.
Search will always return an `Array` of listing `Hashes`.

```ruby
# Search for a specific item
response = skinbaron.search(items: "AK-47 | Redline")

# Search for multiple items
response = skinbaron.search(items: ["AK-47 | Redline", "M4A4 | Urban DDPAT"])
```

#### Search Options

All given options are passed to the Skinbaron API as query parameters.
You can pass any of the following options:

Required:

- `items`: Either a String or an Array of Strings. Only include the weapon name and skin name (e.g. no Factory New, no StatTrak, no Souvenir, etc.)

Optional:

- `pages`: Number of pages to search.
  - Use -1 to get ALL results of the search. Otherwise, Skinbaron will only return 50 results per page.
  - This works by making multiple requests to the API and combining the results.
  - To prevent rate limiting, when multiple pages are requested, a default 3-second delay is enforced between requests
  - Includes duplicate checking to ensure reliable pagination
  - Default is 1 page if not specified

- `min_price`: Minimum price of the items.
- `max_price`: Maximum price of the items.
- `min_wear`: Minimum wear/float value of the items. (0.00 to 1.00)
- `max_wear`: Maximum wear/float value of the items. (0.00 to 1.00)
- `stattrak`: Boolean to filter by StatTrak. (Omit -> all, true -> only StatTrak, false -> only non-StatTrak)
- `souvenir`: Boolean to filter by Souvenir. (Omit -> all, true -> only Souvenir, false -> only non-Souvenir)
- `stackable`: Boolean to filter by Stackable. (Omit -> all, true -> only Stackable, false -> only non-Stackable)
- `tradelocked`: Boolean to filter by Trade-Locked. (Omit -> all, true -> only Trade-Locked, false -> only non-Trade-Locked)
- `items_per_page`: Number of items per page. (Default is 50 which is also the max. Use only if you want to decrease the number of results per page)
- `after_saleid`: ID to start the search after a specific sale.
- `request_delay`: Delay in seconds between requests. (Default is 3 seconds)

Example Requests:

```ruby
skinbaron.search(items: "AK-47 | Redline", pages: -1)
skinbaron.search(items: "AWP | Dragon Lore", pages: -1, min_price: 100, max_price: 1000)
skinbaron.search(items: "P250 | Night", pages: -1, min_wear: 0.00, max_wear: 0.05)
skinbaron.search(items: "M4A4 | Urban DDPAT", pages: 1, items_per_page: 10) # will only return 10 listings (the 10 newest i believe. not sure tho)
```

### Error Handling

The client includes error handling with the following errors:

- `SkinbaronApiClient::AuthenticationError` - API authentication failures
- `SkinbaronApiClient::RequestError` - HTTP request failures
- `SkinbaronApiClient::ResponseError` - Invalid response handling
- `SkinbaronApiClient::Error` - General errors

### Logging

The client logs:

- API requests and responses
- Errors

Logs can be configured during client initialization using:

- `log_path` - Base directory for all logs
- `request_log_path` - Specific file for request logs
- `error_log_path` - Specific file for error logs

### Debugging

To output requests and responses to the console, set the `debug` option to `true` in the client initialization:

```ruby
skinbaron = SkinbaronApiClient::Client.new(api_key: "YOUR_API_KEY", debug: true)
```

## Requirements

- Ruby >= 3.0.0

## Development

After checking out the repo, run `bin/setup` to install dependencies.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b feature/my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin feature/my-new-feature`)
5. Create a new Pull Request

Bug reports and pull requests are welcome on GitHub at <https://github.com/shazam442/skinbaron-api-client>.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
