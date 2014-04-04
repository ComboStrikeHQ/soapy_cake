require 'savon'

module SoapyCake
  class Client
    attr_reader :service, :api_key, :domain

    def initialize(service, opts = {})
      @service = service
      @version = opts[:version]

      @domain = opts.fetch(:domain) do
        if ENV['CAKE_DOMAIN'].present?
          ENV['CAKE_DOMAIN']
        else
          raise 'We need a domain'
        end
      end

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

    def client(method)
      self.class.clients(wsdl(version(method)))
    end

    def self.clients(url)
      @clients ||= {}
      @clients[url] ||= Savon.new(url)
    end

    def method_missing(method, opts = {})
      method = method.to_s
      operation = client(method).operation(service, "#{service}Soap12", method.camelize)
      operation.body = { method.camelize.to_sym => { api_key: api_key }.merge(opts) }
      process_response(method, operation.call.body)
    end

    private

    def process_response(method, response)
      raise response[:fault][:reason][:text] if response[:fault]
      node_name = { 'affiliate_tags' => 'tags' }.fetch(method, method)
      extract_collection(node_name, response[:"#{method}_response"][:"#{method}_result"]).
        map { |hash| remove_prefix(node_name, hash) }
    end

    def extract_collection(node_name, response)
      node_name = node_name.to_sym
      if response.has_key?(node_name)
        return [] if response[node_name].nil?
        response = response[node_name]
      end
      [response[response.keys.first]].flatten
    end

    def remove_prefix(prefix, object)
      object.each_with_object({}) do |(k, v), m|
        prefix_ = "#{prefix.singularize}_"
        if k.to_s.start_with?(prefix_)
          m[k[(prefix_.size)..-1].to_sym] = v
        else
          m[k] = v
        end
      end
    end

    def get_api_key(username, password)
      operation = client(:get_api_key).operation('get', 'getSoap12', 'GetAPIKey')
      operation.body = { GetAPIKey: { username: username, password: password }}
      response = operation.call.body
      response[:get_api_key_response][:get_api_key_result]
    end

    def wsdl(version)
      "https://#{domain}/api/#{version}/#{service}.asmx?WSDL"
    end

    def version(method)
      API_VERSIONS[service][method.to_sym]
    end
  end
end
