module SoapyCake
  class Response
    include Helper

    attr_accessor :time_offset
    attr_reader :body, :short_response

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
        ResponseValue.new(key, value, time_offset: time_offset).parse
      end
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
