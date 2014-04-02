module SoapyCake
  class Client
    attr_reader :api_key

    def initialize(opts)
      @api_key = opts.fetch(:api_key) do
        get_api_key(opts[:username], opts[:password])
      end
    end

    def self.client
      @client ||= Savon.new('http://ad2games-partners.com/api/1/get.asmx?WSDL')
    end

    def method_missing(method, opts={})
      method = method.to_s
      operation = self.class.client.operation('get', 'getSoap12', method.camelize)
      operation.body = { method.camelize.to_sym => { api_key: api_key }.merge(opts) }
      response = operation.call.body
      raise response[:fault][:reason][:text] if response[:fault]
      response[:"#{method}_response"][:"#{method}_result"]
    end

    private

    def get_api_key(username, password)
      operation = self.class.client.operation('get', 'getSoap12', 'GetAPIKey')
      operation.body = { GetAPIKey: { username: username, password: password }}
      response = operation.call.body
      response[:get_api_key_response][:get_api_key_result]
    end
  end
end
