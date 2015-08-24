module SoapyCake
  class Client
    attr_reader :domain, :api_key, :time_offset

    def initialize(opts = {})
      @domain = opts.fetch(:domain, ENV['CAKE_DOMAIN']) || fail(Error, 'Cake domain missing')
      @api_key = opts.fetch(:api_key, ENV['CAKE_API_KEY']) || fail(Error, 'Cake API key missing')
      @time_offset = opts.fetch(:time_offset, ENV['CAKE_TIME_OFFSET']) ||
        fail(Error, 'Cake time offset missing')
      @opts = opts
    end

    protected

    attr_reader :opts

    def run(request)
      request.api_key = api_key
      request.time_offset = time_offset

      http_response(request).public_send(:"to_#{xml_response? ? 'xml' : 'enum'}")
    end

    private

    def xml_response?
      opts[:xml_response] == true
    end

    def http_response(request)
      url = "https://#{domain}#{request.path}"
      http_response = HTTParty.post(url, headers: headers, body: request.xml, timeout: NET_TIMEOUT)

      fail RequestFailed, "Request failed with HTTP #{http_response.code}: " \
        "#{http_response.body}" unless http_response.success?
      response = Response.new(http_response, request.short_response?)
      response.time_offset = time_offset
      response
    end

    def headers
      { 'Content-Type' => 'application/soap+xml;charset=UTF-8' }
    end
  end
end
