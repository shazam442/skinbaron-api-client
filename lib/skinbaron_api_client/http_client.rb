require "http"
require "json"
require_relative "error_handling"
require_relative "logger"

module SkinbaronApiClient
  # HTTP client for making requests to the Skinbaron API
  class HttpClient
    include ErrorHandling

    attr_reader :base_url, :headers, :debug

    def initialize(base_url:, headers: {}, debug: false)
      @base_url = base_url
      @headers = headers
      @debug = debug
    end

    with_error_handling def post(endpoint:, body: {})
      url = "#{base_url}/#{endpoint}"
      debug_log "Making POST request to: #{url}"
      debug_log "Request body: #{body.to_json}"

      start_time = Time.now
      http_response = HTTP.headers(headers).post(url, json: body)

      response = {
        status: http_response.status,
        headers: http_response.headers.to_h,
        body: http_response.body.to_s,
        url: url
      }

      log_request_response(response, url, Time.now - start_time)
      response
    end

    private

    def log_request_response(response, url, duration)
      SkinbaronApiClient::Logger.instance.log_request({
                                                        url: url,
                                                        method: "POST",
                                                        headers: headers,
                                                        body: response[:body],
                                                        status: response[:status],
                                                        duration: duration
                                                      })
    end

    def debug_log(message)
      puts message if debug
    end
  end
end
