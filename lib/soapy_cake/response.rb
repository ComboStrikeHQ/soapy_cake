# frozen_string_literal: true

module SoapyCake
  class Response
    include Helper

    SHORT_ELEMENT_DEPTH = 3
    ELEMENTS_DEPTH = 5

    attr_reader :body, :short_response, :time_converter

    def initialize(body, short_response, time_converter)
      @body = body
      @short_response = short_response
      @time_converter = time_converter
    end

    def to_enum
      check_errors!

      return typed_element(sax.at_depth(SHORT_ELEMENT_DEPTH).first) if short_response

      Enumerator.new do |y|
        sax.at_depth(ELEMENTS_DEPTH).each do |element|
          y << typed_element(element)
        end
      end
    end

    def to_xml
      check_errors!

      (empty? ? [] : [body.to_s]).to_enum
    end

    private

    def empty?
      sax.at_depth(ELEMENTS_DEPTH).first.nil?
    end

    def typed_element(element)
      walk_tree(element) do |value, key|
        ResponseValue.new(key, value, time_converter).parse
      end
    end

    def sax
      @sax ||= Saxerator.parser(StringIO.new(body)) do |config|
        config.symbolize_keys!
        config.ignore_namespaces!
      end
    end

    def check_errors!
      # If we get a lot of data in our response, we can assume there was no error.
      # This saves a lot of time because we don't have to scan the whole XML tree for errors.
      return if body.length > 8192

      error_check_fault!
      return if error_check_special_case?
      error_check_success!
    end

    def error_check_fault!
      fault = sax.for_tag(:fault).first
      raise RequestFailed, fault[:reason][:text] if fault
    end

    def error_check_success!
      return if sax.for_tag(:success).first == 'true'
      raise RateLimitError if error_message == 'Restricted'
      raise RequestFailed, error_message
    end

    def error_check_special_case?
      # Don't ask...
      # As you might imagine, CAKE simply does not return the success element
      # for this specific request. Also, this is the only request with a tag depth
      # of 4, not 3 or 5 like ALL OTHER requests.
      # BTW: There is a 10$ reward if anyone can find a worse designed API.
      return true if sax.for_tag(:MediaType).count.positive?

      false
    end

    def error_message
      @error_message ||= sax.for_tag(:message).first || sax.for_tag(:Text).first || 'Unknown error'
    end
  end
end
