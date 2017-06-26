# frozen_string_literal: true

module SoapyCake
  class ModificationType
    CHANGE = 'change'
    REMOVE = 'remove'
    DO_NOT_CHANGE = 'do_not_change'

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
        input_opts[key] ? CHANGE : REMOVE
      end
    end

    def validate_input(input_opts)
      return unless input_opts[key].nil? && input_opts[modification_type_key] == CHANGE
      raise InvalidInput,
        "`#{modification_type_key}` was '#{CHANGE}', but no `#{key}` was provided to change it to"
    end

    InvalidInput = Class.new(StandardError)
  end
end
