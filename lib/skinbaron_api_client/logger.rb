# frozen_string_literal: true

require "logger"
require "singleton"
require "fileutils"
require "json"

module SkinbaronApiClient
  class Logger
    include Singleton

    LEVELS = %i[debug info warn error fatal].freeze

    attr_reader :logs, :request_logs

    class << self
      def configure(base_path: nil, request_log_path: nil, error_log_path: nil)
        instance.configure(base_path, request_log_path, error_log_path)
      end
    end

    def initialize
      reset!
      @logger = ::Logger.new($stdout)
      @logger.level = ::Logger::INFO
    end

    def configure(base_path, request_log_path, error_log_path)
      @base_path = base_path
      @request_log_path = request_log_path
      @error_log_path = error_log_path

      setup_loggers if should_setup_loggers?
    end

    def reset!
      @logs = []
      @request_logs = []
    end

    def log_request(request_data)
      entry = {
        timestamp: Time.now,
        url: request_data[:url],
        method: request_data[:method],
        headers: request_data[:headers],
        body: request_data[:body],
        response: request_data[:response]&.to_h,
        status: request_data[:status],
        duration: request_data[:duration]
      }

      @request_logs << entry
      write_to_log(@request_logger, entry) if @request_logger
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
        write_to_log(@error_logger, entry) if @error_logger && level == :error
      end
    end

    private

    def should_setup_loggers?
      @base_path || @request_log_path || @error_log_path
    end

    def setup_loggers
      if @request_log_path || (@base_path && !@request_log_path)
        path = @request_log_path || File.join(@base_path, "requests.log")
        @request_logger = setup_file_logger(path)
      end

      return unless @error_log_path || (@base_path && !@error_log_path)

      path = @error_log_path || File.join(@base_path, "errors.log")
      @error_logger = setup_file_logger(path)
    end

    def setup_file_logger(path)
      FileUtils.mkdir_p(File.dirname(path))
      ::Logger.new(path, "daily")
    end

    def write_to_log(logger, entry)
      logger.info(JSON.pretty_generate(entry))
    end
  end
end
