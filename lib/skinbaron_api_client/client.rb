# lib/skinbaron_api_client/client.rb

# frozen_string_literal: true

require_relative "configuration"
require_relative "http_client"
require_relative "error_handling"
require_relative "logger"
require_relative "endpoints/search"

module SkinbaronApiClient
  class Client
    include ErrorHandling

    BASE_URL = "https://api.skinbaron.de"

    attr_reader :config, :http_client, :search_endpoint

    def initialize(**options)
      @config = Configuration.new
      yield @config if block_given?
      configure(**options) unless options.empty?

      @http_client = HttpClient.new(
        base_url: BASE_URL,
        headers: config.base_headers,
        debug: config.debug
      )

      setup_endpoints
      setup_logger
    end

    def configure(**options)
      options.each do |key, value|
        config.public_send("#{key}=", value)
      end
      config.validate!
    end

    def search(item:)
      @search_endpoint.call(item: item)
    end

    with_error_handling def post(endpoint:, body: {})
      body = config.base_body.merge(body)
      response = http_client.post(endpoint: endpoint, body: body)
      check_response(response)
      response
    end

    private

    def setup_endpoints
      @search_endpoint = Endpoints::Search.new(self)
    end

    def setup_logger
      SkinbaronApiClient::Logger.configure(
        base_path: config.log_path,
        request_log_path: config.request_log_path,
        error_log_path: config.error_log_path
      )
    end
  end
end
