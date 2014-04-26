require 'sekken'

module SoapyCake
  class Client
    attr_reader :service, :api_key, :domain, :role

    def initialize(service, opts = {})
      @service = service.to_sym
      @version = opts[:version]
      @role = opts[:role]

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

    def sekken_client(method)
      self.class.sekken_client(wsdl_url(version(method)))
    end

    def self.sekken_client(url)
      @sekken_clients ||= {}
      @sekken_clients[url] ||= Sekken.new(url)
    end

    def method_missing(method, opts = {})
      if is_supported?(method)
        method = method.to_s
        operation = sekken_client(method).operation(service, "#{service}Soap12", method.camelize)
        operation.body = build_body(method, opts)
        process_response(method, operation.call.body)
      else
        super
      end
    end

    private

    def build_body(method, opts)
      {
        method.camelize.to_sym => { api_key: api_key }.merge(
          opts.each_with_object({}) do |(key, value), memo|
            memo[key] = format_param(value)
          end
        )
      }
    end

    def format_param(value)
      case value
      when Time
        value.utc.strftime('%Y-%m-%dT%H:%M:%S')
      when Date
        value.to_time.strftime('%Y-%m-%dT%H:%M:%S')
      else
        value
      end
    end

    def process_response(method, response)
      raise response[:fault][:reason][:text] if response[:fault]
      node_name = { 'affiliate_tags' => 'tags' }.fetch(method, method)
      result = response[:"#{method}_response"][:"#{method}_result"]
      raise result[:message] if result[:success] == false
      extract_collection(node_name, result).
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
      operation = sekken_client(:get_api_key).operation('get', 'getSoap12', 'GetAPIKey')
      operation.body = { GetAPIKey: { username: username, password: password }}
      response = operation.call.body
      response[:get_api_key_response][:get_api_key_result]
    end

    def wsdl_url(version)
      role_path = role ? "/#{role}" : nil
      "https://#{domain}#{role_path}/api/#{version}/#{service}.asmx?WSDL"
    end

    def version(method)
      API_VERSIONS[service][method.to_sym]
    end

    def is_supported?(method)
      API_VERSIONS[service].keys.include?(method)
    end
  end
end
