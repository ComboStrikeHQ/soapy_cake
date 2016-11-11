# frozen_string_literal: true
module SoapyCake
  class ModificationType
    def initialize(key, modification_type_key, default)
      @key = key
      @modification_type_key = modification_type_key
      @default = default
    end

    def options(input_opts)
      validate_input(input_opts)

      input_opts.merge(
        key => value(input_opts),
        modification_type_key => modification_type(input_opts)
      )
    end

    private

    attr_reader :key, :modification_type_key, :default

    def value(input_opts)
      input_opts.fetch(key, default)
    end

    def modification_type(input_opts)
      input_opts.fetch(modification_type_key) do
        input_opts[key] ? 'change' : 'remove'
      end
    end

    def validate_input(input_opts)
      return unless input_opts[key].nil? && input_opts[modification_type_key] == 'change'
      raise InvalidInput,
        "`#{modification_type_key}` was 'change', but no `#{key}` was provided to change it to"
    end

    InvalidInput = Class.new(StandardError)
  end
end
