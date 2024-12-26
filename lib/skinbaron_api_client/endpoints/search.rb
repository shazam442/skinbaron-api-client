module SkinbaronApiClient
  module Endpoints
    class Search
      DEFAULT_REQUEST_DELAY = 3 # seconds
      attr_reader :skinbaron_client, :config, :last_request_time
      attr_accessor :request_delay

      def initialize(skinbaron_client, config)
        @skinbaron_client = skinbaron_client
        @config = config
        @last_request_time = nil
      end

      # if pages is < 1, fetch all pages (one page is max 50 listings by default)
      def call(items:, **options)
        base_body = @skinbaron_client.config.base_body
        body = build_request_body(base_body, items, options)
        target_pages = options[:pages] || 1
        fetch_all = target_pages < 1

        listings = []
        seen_ids = Set.new
        last_saleid = nil
        current_page = 0

        loop do
          enforce_request_delay(delay_seconds: options[:request_delay] || DEFAULT_REQUEST_DELAY)
          body["after_saleid"] = last_saleid if last_saleid

          puts "REQUEST IS BEING MADE" if @config.debug
          response = @skinbaron_client.http_client.post(endpoint: "Search", body: body)
          @last_request_time = Time.now

          response_body = JSON.parse(response[:body])
          current_page_listings = response_body["sales"]

          break if current_page_listings.empty?

          # if any of the current page listings id is in seen_ids, raise error
          raise Error, "pagination failed" if current_page_listings.any? { |listing| seen_ids.include?(listing["id"]) }

          current_page_listings.each do |listing|
            seen_ids.add(listing["id"])
            listings << listing
          end

          last_saleid = current_page_listings.last["id"]
          current_page += 1
          break if !fetch_all && current_page >= target_pages
        end

        listings
      rescue JSON::ParserError => e
        logger.error("Failed to parse search response", error: e.message)
        raise e
      end

      private

      def enforce_request_delay(delay_seconds:)
        return unless @last_request_time

        elapsed = Time.now - @last_request_time
        remaining_delay = delay_seconds - elapsed

        return unless remaining_delay.positive?

        sleep(remaining_delay)
      end

      def build_request_body(base_body, items, options)
        items_query = items.join(";")
        base_body.merge({
                          "search_item" => items_query
                        }).tap do |body|
          body["min"] = options[:min_price] if options.key?(:min_price)
          body["max"] = options[:max_price] if options.key?(:max_price)
          body["minwear"] = options[:min_wear] if options.key?(:min_wear)
          body["maxwear"] = options[:max_wear] if options.key?(:max_wear)
          body["stattrak"] = options[:stattrak] if options.key?(:stattrak)
          body["souvenir"] = options[:souvenir] if options.key?(:souvenir)
          body["stackable"] = options[:stackable] if options.key?(:stackable)
          body["tradelocked"] = options[:tradelocked] if options.key?(:tradelocked)
          body["items_per_page"] = options[:items_per_page] if options.key?(:items_per_page)
          body["after_saleid"] = options[:after_saleid] if options.key?(:after_saleid)
        end
      end
    end
  end
end
