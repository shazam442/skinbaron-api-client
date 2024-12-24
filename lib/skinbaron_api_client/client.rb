# lib/skinbaron_api_client/client.rb

# frozen_string_literal: true

require_relative "logger"
require_relative "error_handling"

module SkinbaronApiClient
  # Example usage:
  #   skinbaron = SkinbaronApiClient::Client.new(api_key: "your_api_key", appid: 730) # 730 -> Counter Strike 2
  #   response = skinbaron.search(item: "AK-47 | Redline")
  #   puts response
  #
  # Methods:
  # - initialize(api_key:, appid: 730): Initializes the client with the given API key and app ID.
  # - search(item:): Searches for an item on Skinbaron and returns the response.
  #
  # Private Methods:
  # - base_body: Returns the base request body with the API key and app ID.
  # - base_headers: Returns the base request headers.
  class Client
    include ErrorHandling

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

      log_request_start(url: request_url, headers: request_headers, body: request_body)
      make_timed_request(headers: request_headers, url: request_url, body: request_body)
    end
    with_error_handling :post

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

    def logger
      SkinbaronApiClient::Logger.instance
    end

    def log_request_start(url:, headers:, body:)
      logger.debug("Making POST request", { url: url, headers: headers, body: body })
    end

    def log_request_complete(response:, duration:)
      logger.log_request({
                           url: response.request.uri,
                           method: :post,
                           headers: response.headers.to_h,
                           body: response.body.to_s,
                           response: response&.body,
                           status: response&.status,
                           duration: duration
                         })
    end

    def log_error(message:, error:)
      logger.error(message, { error: error.message, backtrace: error.backtrace })
    end

    def make_timed_request(headers:, url:, body:)
      start_time = Time.now
      response = HTTP.headers(headers).post(url, json: body)
      log_request_complete(response: response, duration: Time.now - start_time)
      response
    end
  end
end
