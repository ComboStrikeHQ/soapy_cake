module SoapyCake
  class Client
    HEADERS = { 'Content-Type' => 'application/soap+xml;charset=UTF-8' }.freeze

    def initialize(opts = {})
      @domain = opts.fetch(:domain, ENV['CAKE_DOMAIN']) || fail(Error, 'Cake domain missing')
      @api_key = opts.fetch(:api_key, ENV['CAKE_API_KEY']) || fail(Error, 'Cake API key missing')
      @retry_count = opts.fetch(:retry_count, ENV['CAKE_RETRY_COUNT']) || 4

      @time_converter = TimeConverter.new(
        opts.fetch(:time_zone, ENV['CAKE_TIME_ZONE']),
        opts.fetch(:time_offset, ENV['CAKE_TIME_OFFSET'])
      )

      @opts = opts
    end

    def xml_response?
      opts[:xml_response] == true
    end

    protected

    attr_reader :domain, :api_key, :time_converter, :opts, :logger, :retry_count

    def run(request)
      request.api_key = api_key
      request.time_converter = time_converter

      Retryable.retryable(
        tries: retry_count + 1,
        on: [RateLimitError, SocketError],
        sleep: -> (n) { 3**n }
      ) do
        response = Response.new(response_body(request), request.short_response?, time_converter)
        xml_response? ? response.to_xml : response.to_enum
      end
    end

    private

    def logger
      @logger ||= opts[:logger] || (defined?(::Rails) && ::Rails.logger)
    end

    def response_body(request)
      request.opts[:response].presence || http_response(request)
    end

    def http_response(request)
      logger.info("soapy_cake:request #{request}") if logger

      url = "https://#{domain}#{request.path}"
      http_response = HTTParty.post(url, headers: HEADERS, body: request.xml, timeout: NET_TIMEOUT)

      fail RequestFailed, "Request failed with HTTP #{http_response.code}: " \
        "#{http_response.body}" unless http_response.success?

      http_response
    end
  end
end
