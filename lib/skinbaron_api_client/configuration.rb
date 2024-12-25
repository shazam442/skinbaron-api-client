module SkinbaronApiClient
  class Configuration
    attr_accessor :api_key, :appid, :log_path, :request_log_path, :error_log_path, :debug
    attr_reader :base_url

    def initialize
      @base_url = "https://api.skinbaron.de"
      @appid = 730 # Default to CS2
      @debug = false
    end

    def validate!
      raise ArgumentError, "api_key is required" unless api_key
    end

    def base_headers
      {
        "Content-Type" => "application/json",
        "Accept" => "application/json",
        "X-Requested-With" => "XMLHttpRequest"
      }
    end

    def base_body
      {
        "apikey" => api_key,
        "appid" => appid
      }
    end
  end
end
