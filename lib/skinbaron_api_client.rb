# lib/skinbaron_api_client.rb

# frozen_string_literal: true

require "http"
require "json"
require_relative "skinbaron_api_client/version"
require_relative "skinbaron_api_client/client"
require_relative "skinbaron_api_client/logger"

# Example usage:
#
# skinbaron = SkinbaronApiClient::Client.new(api_key: "your-api-key")
#
# # Search for a specific CS2 item
# response = skinbaron.search(item: "AK-47 | Asiimov")
#
module SkinbaronApiClient
end
