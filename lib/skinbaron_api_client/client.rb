# lib/skinbaron_api_client/client.rb

# frozen_string_literal: true

module SkinbaronApiClient
  class Error < StandardError; end

  # Example usage:
  #   skinbaron = SkinbaronApiClient::Client.new(api_key: "your_api_key", appid: 730) # 730 -> Counter Strike 2
  #   response = skinbaron.search(item: "AK-47 | Redline")
  #   puts response
  #
  # Methods:
  # - initialize(api_key:, appid: 730): Initializes the client with the given API key and app ID.
  # - search(item:): Searches for an item on Skinbaron and returns the response.
  # - write_to_file(data): Writes the given data to a JSON file.
  #
  # Private Methods:
  # - base_body: Returns the base request body with the API key and app ID.
  # - base_headers: Returns the base request headers.
  class Client
    BASE_URL = "https://api.skinbaron.de/"

    def initialize(api_key:, appid: 730)
      @api_key = api_key
      @appid = appid
    end

    def search(item:)
      url = "#{BASE_URL}Search"

      request_body = base_body.merge({ "search_item": item })
      request_headers = base_headers

      response = HTTP.headers(request_headers)
                     .post(url, json: request_body)

      JSON.parse(response.body.to_s)
    rescue HTTP::Error => e
      raise Error, "HTTP request failed: #{e.message}"
    rescue JSON::ParserError => e
      raise Error, "Failed to parse JSON response: #{e.message}"
    end

    private

    def base_body
      {
        "apikey": @api_key,
        "appid": @appid
      }
    end

    def base_headers
      {
        "Content-Type" => "application/json",
        "Accept" => "application/json",
        "X-Requested-With" => "XMLHttpRequest"
      }
    end
  end
end
