module SoapyCake
  class Response
    attr_accessor :time_offset
    attr_reader :body

    def initialize(body)
      @body = body
    end

    def collection
      check_errors!

      sax.at_depth(5).map do |element|
        typed_element(element)
      end
    end

    private

    def typed_element(element)
      Helper.walk_tree(element) do |value, key|
        next value.to_i if key.to_s.end_with?('_id')

        if /\A\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.?\d*\z/.match(value)
          next DateTime.parse(value + format('%+03d:00', time_offset.to_i))
        end

        next false if value == 'false'
        next true if value == 'true'

        value
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
      fail RequestFailed, sax.for_tag(:Text).first unless sax.for_tag(:success).first == 'true'
    end
  end
end
