module SkinbaronApiClient
  class Error < StandardError; end

  class AuthenticationError < Error; end

  class RequestError < Error; end

  class ResponseError < Error; end

  class TooManyRequestsError < Error; end
end
