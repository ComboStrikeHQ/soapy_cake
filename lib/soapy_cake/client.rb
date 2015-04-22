module SoapyCake
  class Client
    attr_reader :domain, :api_key, :time_offset

    def initialize(opts = {})
      @domain = opts.fetch(:domain, ENV['CAKE_DOMAIN']) || fail(Error, 'Cake domain missing')
      @api_key = opts.fetch(:api_key, ENV['CAKE_API_KEY']) || fail(Error, 'Cake API key missing')

      username = opts.delete(:username) || ENV['CAKE_USERNAME'] || fail(Error, 'Cake username missing')
      password = opts.delete(:password) || ENV['CAKE_PASSWORD'] || fail(Error, 'Cake password missing')
      @time_offset = instance_time_offset(username, password)

      @opts = opts
    end

    protected

    attr_reader :opts

    def run(request)
      request.api_key = api_key
      request.time_offset = time_offset

      url = "https://#{domain}#{request.path}"
      body = HTTParty.post(url, headers: headers, body: request.xml, timeout: NET_TIMEOUT).body

      response = Response.new(body, %w(addedit track).include?(request.service))
      response.time_offset = time_offset
      response.collection
    end

    private

    def instance_time_offset(username, password)
      auth_info = run(Request.new(:admin, :auth, :login, username: username, password: password))
      timezone = auth_info.last
      dst = timezone.slice!(' Daylight Time')

      (TZInfo::Timezone.get(timezone).current_period.utc_offset + (dst ? 1.hour : 0)) / 1.hour
    end

    def headers
      { 'Content-Type' => 'application/soap+xml;charset=UTF-8' }
    end
  end
end
