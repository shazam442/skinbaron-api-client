module SkinbaronApiClient
  module Endpoints
    class Search
      attr_reader :client

      def initialize(client)
        @client = client
      end

      def call(item:)
        body = { "search_item": item }
        response = client.post(endpoint: "Search", body: body)
        response[:parsed_body]
      end
    end
  end
end
