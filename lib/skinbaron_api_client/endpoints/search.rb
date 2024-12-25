module SkinbaronApiClient
  module Endpoints
    class Search
      attr_reader :skinbaron_client

      def initialize(skinbaron_client)
        @skinbaron_client = skinbaron_client
      end

      def call(item:)
        body = { "search_item": item }
        response = @skinbaron_client.http_client.post(endpoint: "Search", body: body)
        response[:parsed_body]
      end
    end
  end
end
