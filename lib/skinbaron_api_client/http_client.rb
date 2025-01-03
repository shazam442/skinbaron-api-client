require "http"
require "json"
require_relative "logger"

module SkinbaronApiClient
  # HTTP client for making requests to the Skinbaron API
  class HttpClient
    attr_reader :base_url, :headers, :debug

    def initialize(base_url:, headers: {}, debug: false)
      @base_url = base_url
      @headers = headers
      @debug = debug
    end

    def post(endpoint:, body: {})
      url = "#{base_url}/#{endpoint}"
      debug_log "Making POST request to: #{url}"
      debug_log "Request body: #{body.to_json}"

      Logger.instance.log({
                            type: "REQUEST",
                            url: url,
                            method: "POST",
                            headers: headers,
                            body: body
                          })

      http_response = HTTP.headers(headers).post(url, json: body)
      raise AuthenticationError, "Authentication failed" if http_response.body.to_s.include? "wrong or unauthenticated"

      Logger.instance.log({
                            type: "RESPONSE",
                            url: url,
                            status: http_response.status.to_s,
                            body: http_response
                          })

      {
        status: http_response.status,
        headers: http_response.headers.to_h,
        body: http_response.body.to_s,
        url: url
      }
    end

    private

    def debug_log(message)
      puts message if debug
    end
  end
end
