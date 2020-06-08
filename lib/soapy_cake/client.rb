# frozen_string_literal: true

require 'net/http'
require 'active_support/tagged_logging'

# rubocop:disable Metrics/ClassLength
module SoapyCake
  class Client
    HEADERS = { 'Content-Type' => 'application/soap+xml;charset=UTF-8' }.freeze

    def initialize(opts = {})
      @opts = opts
      @domain = fetch_opt(:domain) || raise(Error, 'Cake domain missing')
      @api_key = fetch_opt(:api_key) || raise(Error, 'Cake API key missing')
      @retry_count = fetch_opt(:retry_count, 4)
      @write_enabled = ['yes', true].include?(fetch_opt(:write_enabled))
      @time_converter = TimeConverter.new(fetch_opt(:time_zone))
    end

    def xml_response?
      opts[:xml_response] == true
    end

    def read_only?
      !write_enabled
    end

    def run(request)
      check_write_enabled!(request)
      request.api_key = api_key
      request.time_converter = time_converter

      with_retries do
        response = Response.new(response_body(request), request.short_response?, time_converter)
        xml_response? ? response.to_xml : response.to_enum
      rescue RequestFailed => e
        raise RequestFailed.new(
          e.message,
          request_path: request.path,
          request_body: request.xml,
          response_body: e.response_body || response.body
        )
      end
    end

    protected

    attr_reader :domain, :api_key, :time_converter, :opts, :retry_count, :write_enabled

    private

    def fetch_opt(key, fallback = nil)
      opts.fetch(key, ENV.fetch("CAKE_#{key.to_s.upcase}", fallback))
    end

    def check_write_enabled!(request)
      return if request.read_only? || write_enabled

      raise Error, 'Writes not enabled (pass write_enabled: true or set CAKE_WRITE_ENABLED=yes)'
    end

    def with_retries(&block)
      opts = { tries: retry_count + 1, on: [RateLimitError, SocketError], sleep: ->(n) { 3**n } }
      Retryable.retryable(opts, &block)
    end

    def response_body(request)
      request.opts[:response].presence || http_response(request)
    end

    def http_response(request)
      response = nil
      logger.tagged('soapy_cake', unique_id) do
        log_request(request)
        response = perform_http_request(http_request(request))
        log_response(response)
      end

      raise_if_unsuccessful(response)
      response.body
    end

    def http_request(request)
      http_req = Net::HTTP::Post.new(request.path, HEADERS)
      http_req.body = request.xml
      http_req
    end

    def unique_id
      SecureRandom.hex(4)
    end

    def log_request(request)
      logger.tagged('request') do
        logger.info(
          request
            .xml
            .gsub(/>[\n\s]+</, '><')
            .sub(request.api_key, '[REDACTED]')
        )
      end
    end

    def log_response(response)
      logger.tagged('response', response.code) do
        logger.info(response.body)
      end
    end

    def logger
      @logger ||= ActiveSupport::TaggedLogging.new(
        opts[:logger] || (defined?(::Rails) && ::Rails.logger) || Logger.new('/dev/null')
      )
    end

    def perform_http_request(http_request)
      t0 = Time.now
      response = Net::HTTP.start(
        domain,
        use_ssl: true,
        open_timeout: NET_TIMEOUT,
        read_timeout: NET_TIMEOUT
      ) do |http|
        http.request(http_request)
      end
      logger.info("took: #{(Time.now - t0).round(2)} s")
      response
    end

    def raise_if_unsuccessful(response)
      return if response.is_a?(Net::HTTPSuccess)

      raise RequestFailed.new(
        "Request failed with HTTP #{response.code}",
        response_body: response.body
      )
    end
  end
end
# rubocop:enable Metrics/ClassLength
