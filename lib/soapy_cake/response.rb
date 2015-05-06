module SoapyCake
  class Response
    include Helper

    attr_accessor :time_offset
    attr_reader :body, :short_response

    STRING_IDS = %w(tax_id transaction_id)

    def initialize(body, short_response)
      @body = body
      @short_response = short_response
    end

    def collection
      check_errors!

      return typed_element(sax.at_depth(3).first) if short_response

      sax.at_depth(5).map do |element|
        typed_element(element)
      end
    end

    private

    def typed_element(element)
      walk_tree(element) do |value, key|
        parse_element(key, value)
      end
    end

    def parse_element(key, value)
      return value.to_i if key.to_s.end_with?('_id') && !string_id?(key.to_s)
      return false if value == 'false'
      return true if value == 'true'
      return parse_date(value) if /\A\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.?\d*\z/.match(value)

      # cast to primitive string to get rid of Saxerator string class
      value.to_s
    end

    def parse_date(value)
      DateTime.parse(value + format('%+03d:00', time_offset.to_i))
    end

    def string_id?(key)
      STRING_IDS.any? { |id| key.end_with?(id) }
    end

    def sax
      @sax ||= Saxerator.parser(StringIO.new(body)) do |config|
        config.symbolize_keys!
        config.ignore_namespaces!
      end
    end

    def check_errors!
      fault = sax.for_tag(:fault).first
      fail RequestFailed, fault[:reason][:text] if fault
      fail RequestFailed, error_message unless sax.for_tag(:success).first == 'true'
    end

    def error_message
      sax.for_tag(:message).first || sax.for_tag(:Text).first || 'Unknown error'
    end
  end
end
