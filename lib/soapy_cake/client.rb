module SoapyCake
  class Client
    attr_reader :domain, :api_key, :time_converter

    def initialize(opts = {})
      @domain = opts.fetch(:domain, ENV['CAKE_DOMAIN']) || fail(Error, 'Cake domain missing')
      @api_key = opts.fetch(:api_key, ENV['CAKE_API_KEY']) || fail(Error, 'Cake API key missing')

      time_offset = opts.fetch(:time_offset, ENV['CAKE_TIME_OFFSET'])
      time_zone = opts.fetch(:time_zone, ENV['CAKE_TIME_ZONE'])
      @time_converter = TimeConverter.new(time_zone, time_offset)

      @opts = opts
    end

    def xml_response?
      opts[:xml_response] == true
    end

    protected

    attr_reader :opts

    def run(request)
      request.api_key = api_key
      request.time_converter = time_converter

      response = Response.new(response_body(request), request.short_response?, time_converter)
      xml_response? ? response.to_xml : response.to_enum
    end

    private

    def response_body(request)
      if request.opts[:response].present?
        request.opts[:response]
      else
        http_response(request)
      end
    end

    def http_response(request)
      url = "https://#{domain}#{request.path}"
      http_response = HTTParty.post(url, headers: headers, body: request.xml, timeout: NET_TIMEOUT)

      fail RequestFailed, "Request failed with HTTP #{http_response.code}: " \
        "#{http_response.body}" unless http_response.success?

      http_response
    end

    def headers
      { 'Content-Type' => 'application/soap+xml;charset=UTF-8' }
    end
  end
end
