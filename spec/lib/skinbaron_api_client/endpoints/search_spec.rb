require "spec_helper"

RSpec.describe SkinbaronApiClient::Endpoints::Search do
  let(:config) { instance_double(SkinbaronApiClient::Configuration, base_body: {}) }
  let(:http_client) { instance_double(SkinbaronApiClient::HttpClient) }
  let(:client) { instance_double(SkinbaronApiClient::Client, config: config, http_client: http_client) }
  let(:search) { described_class.new(client) }

  describe "#call" do
    let(:search_response) { File.read("spec/fixtures/search_response.json") }
    let(:successful_response) { { status: double(success?: true), body: search_response } }

    context "with price range filters" do
      it "returns only items within the specified price range" do
        expect(http_client).to receive(:post).with(
          endpoint: "Search",
          body: hash_including(
            "min" => 100,
            "max" => 150
          )
        ).and_return(successful_response)

        results = search.call(items: ["AK-47 | Redline"], min_price: 100, max_price: 150)

        expect(results).to all(satisfy { |item| item["price"].between?(100, 150) })
      end
    end

    context "with wear range filters" do
      it "returns only items within the specified wear range" do
        expect(http_client).to receive(:post).with(
          endpoint: "Search",
          body: hash_including(
            "minwear" => 0.15,
            "maxwear" => 0.37
          )
        ).and_return(successful_response)

        results = search.call(items: ["AK-47 | Redline"], min_wear: 0.15, max_wear: 0.37)

        expect(results).to all(satisfy { |item| item["wear"].between?(0.15, 0.37) })
      end
    end

    context "with StatTrak filter" do
      it "respects the StatTrak filter setting" do
        expect(http_client).to receive(:post).with(
          endpoint: "Search",
          body: hash_including("stattrak" => false)
        ).and_return(successful_response)

        search.call(items: ["AK-47 | Redline"], allow_stattrak: false)
      end
    end

    context "with multiple items search" do
      it "joins multiple items with semicolons" do
        expect(http_client).to receive(:post).with(
          endpoint: "Search",
          body: hash_including("search_item" => "AK-47 | Redline;M4A4 | Asiimov")
        ).and_return(successful_response)

        search.call(items: ["AK-47 | Redline", "M4A4 | Asiimov"])
      end
    end

    context "with pagination" do
      it "respects the items per page setting" do
        expect(http_client).to receive(:post).with(
          endpoint: "Search",
          body: hash_including("items_per_page" => 50)
        ).and_return(successful_response)

        search.call(items: ["AK-47 | Redline"], items_per_page: 50)
      end

      it "handles after_saleid for pagination" do
        expect(http_client).to receive(:post).with(
          endpoint: "Search",
          body: hash_including("after_saleid" => "some-sale-id")
        ).and_return(successful_response)

        search.call(items: ["AK-47 | Redline"], after_saleid: "some-sale-id")
      end
    end
  end
end
