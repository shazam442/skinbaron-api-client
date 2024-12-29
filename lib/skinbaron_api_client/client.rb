# lib/skinbaron_api_client/client.rb

# frozen_string_literal: true

require_relative "configuration"
require_relative "http_client"
require_relative "logger"
require_relative "endpoints/search"

module SkinbaronApiClient
  class Client
    attr_reader :config, :http_client, :search_endpoint

    def initialize(**options)
      @config = Configuration.new
      configure(**options) unless options.empty?
      yield @config if block_given?
      config.validate!

      @http_client = setup_http_client
      setup_endpoints
      setup_logger
    end

    def configure(**options)
      options.each do |key, value|
        config.public_send("#{key}=", value)
      end
    end

    def search(items:, **options)
      items = Array(items)
      @search_endpoint.call(items: items, **options) || []
    end

    private

    def setup_http_client
      HttpClient.new(
        base_url: config.base_url,
        headers: config.base_headers,
        debug: config.debug
      )
    end

    def setup_endpoints
      @search_endpoint = Endpoints::Search.new(self, @config)
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
