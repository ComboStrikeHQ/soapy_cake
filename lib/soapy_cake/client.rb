module SoapyCake
  class Client
    attr_reader :api_key

    def initialize(opts = {})
      @api_key = opts.fetch(:api_key) do
        if opts[:username] && opts[:password]
          get_api_key(opts[:username], opts[:password])
        elsif ENV['CAKE_API_KEY']
          ENV['CAKE_API_KEY']
        else
          raise 'We need an API key here!'
        end
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
      node_name = { "affiliate_tags" => "tags" }.fetch(method, method)
      extract_collection(node_name, response[:"#{method}_response"][:"#{method}_result"]).
        map {|hash| remove_prefix(node_name, hash) }
    end

    private

    def extract_collection(node_name, response)
      node_name = node_name.to_sym
      if response.has_key?(node_name)
        response = response[node_name]
      end
      [response[response.keys.first]].flatten
    end

    def remove_prefix(prefix, object)
      object.each_with_object({}) do |(k,v),m|
        prefix_ = "#{prefix.singularize}_"
        if k.to_s.start_with?(prefix_)
          m[k[(prefix_.size)..-1].to_sym] = v
        else
          m[k] = v
        end
      end
    end

    def get_api_key(username, password)
      operation = self.class.client.operation('get', 'getSoap12', 'GetAPIKey')
      operation.body = { GetAPIKey: { username: username, password: password }}
      response = operation.call.body
      response[:get_api_key_response][:get_api_key_result]
    end
  end
end
