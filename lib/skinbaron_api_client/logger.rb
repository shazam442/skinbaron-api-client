# frozen_string_literal: true

require "logger"
require "singleton"

module SkinbaronApiClient
  class Logger
    include Singleton

    LEVELS = %i[debug info warn error fatal].freeze

    attr_reader :logs, :request_logs

    def initialize
      reset!
      @logger = ::Logger.new($stdout)
      @logger.level = ::Logger::INFO # Default level
    end

    def reset!
      @logs = []
      @request_logs = []
    end

    def log_request(request_data)
      @request_logs << {
        timestamp: Time.now,
        url: request_data[:url],
        method: request_data[:method],
        headers: request_data[:headers],
        body: request_data[:body],
        response: request_data[:response]&.to_h,
        status: request_data[:status],
        duration: request_data[:duration]
      }
    end

    LEVELS.each do |level|
      define_method(level) do |message, metadata = {}|
        entry = {
          timestamp: Time.now,
          level: level,
          message: message,
          metadata: metadata
        }

        @logs << entry
        @logger.send(level, message)
      end
    end

    def set_level(level)
      @logger.level = ::Logger.const_get(level.to_s.upcase)
    end
  end
end
