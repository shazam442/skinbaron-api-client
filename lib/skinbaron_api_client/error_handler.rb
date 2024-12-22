# frozen_string_literal: true

module SkinbaronApiClient
  # yea
  class ErrorHandler
    def self.check_response(res)
      if res.body.to_s.include? "wrong or unauthenticated request"
        raise AuthenticationError, "Authentication failed: #{res.body}"
      end
      raise Error, "Request to \"#{res.request.uri}\" failed" unless res&.status&.success?
    end

    def self.print_error(err, response = nil)
      # Just print the error and response to the console
      puts "Error: #{err.message}"
      puts "Response: #{JSON.pretty_generate(response&.body.to_h)}" if response
    end
  end
end
