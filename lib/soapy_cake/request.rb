module SoapyCake
  class Request
    DATE_CLASSES = [Date, Time, DateTime].freeze

    attr_accessor :api_key, :time_converter
    attr_reader :role, :service, :method, :opts

    def initialize(role, service, method, opts = {})
      @role = role.to_s
      @service = service.to_s
      @method = method.to_s
      @opts = opts
    end

    def path
      "#{api_path}/#{service}.asmx"
    end

    def xml
      Nokogiri::XML::Builder.new do |xml|
        xml['env'].Envelope(xml_namespaces) do
          xml.Header
          xml.Body do
            xml['cake'].public_send(method.camelize.to_sym) do
              xml_params(xml)
            end
          end
        end
      end.to_xml
    end

    def short_response?
      %w(addedit track signup).include?(service)
    end

    private

    def api_path
      "#{(role == 'admin') ? '' : "/#{role.pluralize}"}/api/#{version}"
    end

    def xml_params(xml)
      xml.api_key api_key
      opts.each do |k, v|
        xml.public_send(k.to_sym, format_param(k, v))
      end
    end

    def xml_namespaces
      {
        'xmlns:env' => 'http://www.w3.org/2003/05/soap-envelope',
        'xmlns:cake' => "http://cakemarketing.com#{api_path}/"
      }
    end

    def format_param(key, value)
      return time_converter.to_cake(value) if DATE_CLASSES.include?(value.class)

      if key.to_s.end_with?('_date')
        fail Error, "You need to use a Time/DateTime/Date object for '#{key}'"
      end

      value
    end

    def version
      API_VERSIONS[role][service][method] || fail
    rescue
      raise(Error, "Unknown API call #{role}::#{service}::#{method}")
    end
  end
end
