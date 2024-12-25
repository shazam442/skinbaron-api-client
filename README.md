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
results = skinbaron.search(item: "AK-47 | Redline")

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

### Search Items

Search for items on the SkinBaron marketplace:

```ruby
# Search for a specific item
response = skinbaron.search(item: "AK-47 | Redline")
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
