# lib/skinbaron_api_client/client.rb

# frozen_string_literal: true

require_relative "error_handler"

module SkinbaronApiClient
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
    BASE_URL = "https://api.skinbaron.de"

    def initialize(api_key:, appid: 730)
      @api_key = api_key
      @appid = appid
    end

    def search(item:)
      body = { "search_item": item }

      response = post(endpoint: "Search", body: body)
      JSON.parse(response.body.to_s)
    end

    private

    def post(endpoint:, headers: {}, body: {})
      request_url = "#{BASE_URL}/#{endpoint}"
      request_headers = base_headers.merge(headers)
      request_body = base_body.merge(body)

      response = HTTP.headers(request_headers).post(request_url, json: request_body)
      ErrorHandler.check_response(response)

      response
    rescue StandardError => e
      ErrorHandler.print_error(e, response || nil)
    end

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
