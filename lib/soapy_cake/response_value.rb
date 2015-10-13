module SoapyCake
  class ResponseValue
    attr_reader :value
    attr_reader :key

    # Known string ids that should not be parsed as integers
    STRING_IDS = %w(tax_id transaction_id).freeze

    def initialize(key, value, time_converter)
      @key = key.to_s
      @value = value
      @time_converter = time_converter
    end

    def parse
      return parse_int if id? && !string_id?
      return false if false?
      return true if true?
      return time_converter.from_cake(value) if date?

      # cast to primitive string to get rid of Saxerator string class
      value.to_s
    end

    private

    attr_reader :time_converter

    def false?
      value == 'false'
    end

    def true?
      value == 'true'
    end

    def date?
      value =~ /\A\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.?\d*\z/
    end

    def id?
      key.to_s.end_with?('_id')
    end

    def string_id?
      STRING_IDS.any? { |id| key.end_with?(id) }
    end

    def numeric?
      value =~ /\A-?\d*\z/
    end

    def parse_int
      unless value.nil? || numeric?
        fail Error, "'#{key}' contains non-digit chars but was to be parsed as an integer id"
      end
      value.to_i
    end
  end
end
