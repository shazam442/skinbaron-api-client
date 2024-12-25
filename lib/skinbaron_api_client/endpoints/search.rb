module SkinbaronApiClient
  module Endpoints
    class Search
      attr_reader :skinbaron_client

      def initialize(skinbaron_client)
        @skinbaron_client = skinbaron_client
      end

      def call(item:)
        body = @skinbaron_client.config.base_body.merge({ "search_item": item })
        response = @skinbaron_client.http_client.post(endpoint: "Search", body: body)

        return nil unless response[:status].success?

        JSON.parse(response[:body])
      rescue JSON::ParserError => e
        logger.error("Failed to parse search response", error: e.message)
        nil
      end
    end
  end
end
