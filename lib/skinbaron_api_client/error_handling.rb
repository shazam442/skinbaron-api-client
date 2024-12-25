# frozen_string_literal: true

# Provides error handling functionality for API requests.
# Includes methods for checking responses, logging errors,
# and wrapping methods with standardized error handling.
module SkinbaronApiClient
  # Mixin for adding error handling capabilities to API client classes.
  # Provides methods for response validation and error logging.
  module ErrorHandling
    def self.included(base)
      base.extend(ClassMethods)
    end

    # Class methods for decorating instance methods with error handling.
    # Provides the with_error_handling decorator for wrapping methods.
    module ClassMethods
      def with_error_handling(method_name)
        original_method = instance_method(method_name)

        define_method(method_name) do |*args, **kwargs|
          response = original_method.bind(self).call(*args, **kwargs)

          check_response_success(response)
          check_response_authentication(response)

          response
        rescue HTTP::Error => e
          log_error(message: "HTTP request failed", error: e)
          raise RequestError, "HTTP request failed: #{e.message}"
        rescue JSON::ParserError => e
          log_error(message: "JSON parsing failed", error: e)
          raise ResponseError, "Invalid JSON response: #{e.message}"
        end
      end
    end

    private

    def logger
      SkinbaronApiClient::Logger.instance
    end

    def log_error(message:, error:)
      logger.error(
        message,
        {
          error_class: error.class.name,
          error_message: error.message,
          backtrace: error.backtrace&.first(5)
        }
      )
    end

    def check_response_success(response)
      return if response[:status]&.success?

      raise ResponseError, "Request failed with status #{response[:status]}. Response: #{response[:body]}"
    end

    def check_response_authentication(response)
      return unless response[:body].to_s.include? "wrong or unauthenticated request"

      logger.error("Authentication failed", { body: response[:body] })
      raise AuthenticationError, "Authentication failed: #{response[:body]}"
    end
  end
end
