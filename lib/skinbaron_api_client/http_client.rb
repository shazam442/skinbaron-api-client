require "http"
require "json"

module SkinbaronApiClient
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

      start_time = Time.now
      http_response = HTTP.headers(headers).post(url, json: body)

      response = build_response(http_response, url)
      response.merge!(duration: Time.now - start_time)

      debug_log "Response status: #{response[:status]}"
      debug_log "Response body: #{response[:body]}"

      response
    end

    private

    def build_response(http_response, url)
      {
        status: http_response.status,
        headers: http_response.headers.to_h,
        body: http_response.body.to_s,
        url: url,
        parsed_body: parse_body(http_response)
      }
    end

    def parse_body(response)
      JSON.parse(response.body.to_s) if response.status.success?
    end

    def debug_log(message)
      puts message if debug
    end
  end
end
