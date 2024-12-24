# frozen_string_literal: true

module SkinbaronApiClient
  module ErrorHandling
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def with_error_handling(method_name)
        original_method = instance_method(method_name)

        define_method(method_name) do |*args, **kwargs|
          response = original_method.bind(self).call(*args, **kwargs)
          check_response(response)
          response
        rescue HTTP::Error => e
          log_error(message: "HTTP request failed", error: e)
          raise RequestError, "HTTP request failed: #{e.message}"
        rescue JSON::ParserError => e
          log_error(message: "JSON parsing failed", error: e)
          raise ResponseError, "Invalid JSON response: #{e.message}"
        rescue StandardError => e
          log_error(message: "Unexpected error", error: e)
          raise Error, "Unexpected error: #{e.message}"
        end
      end
    end

    private

    def check_response(response)
      if response.body.to_s.include? "wrong or unauthenticated request"
        logger.error("Authentication failed", { body: response.body })
        raise AuthenticationError, "Authentication failed: #{response.body}"
      end

      return if response&.status&.success?

      logger.error("Request failed", {
                     uri: response.request.uri,
                     status: response.status,
                     body: response.body
                   })

      raise ResponseError,
            "Request to \"#{response.request.uri}\" failed with status #{response.status}. Response: #{response.body}"
    end
  end
end
