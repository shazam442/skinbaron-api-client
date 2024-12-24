# lib/skinbaron_api_client.rb

# frozen_string_literal: true

require "http"
require "json"
require_relative "skinbaron_api_client/version"
require_relative "skinbaron_api_client/client"
require_relative "skinbaron_api_client/logger"
require_relative "skinbaron_api_client/error_handling"

module SkinbaronApiClient
  class Error < StandardError; end

  class AuthenticationError < Error; end

  class RequestError < Error; end

  class ResponseError < Error; end
end
