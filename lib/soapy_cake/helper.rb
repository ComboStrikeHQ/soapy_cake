# frozen_string_literal: true
module SoapyCake
  module Helper
    def walk_tree(obj, key = nil, &block)
      return nil if obj == {}

      case obj
      when Hash
        obj.map { |hk, hv| [hk, walk_tree(hv, hk, &block)] }.to_h
      when Array
        obj.map { |av| walk_tree(av, &block) }
      else
        yield(obj, key)
      end
    end

    def validate_id(opts, key)
      raise Error, "Parameter '#{key}' must be > 0!" if opts[key].to_i < 1
    end

    def require_params(opts, params)
      params.each do |param|
        raise Error, "Parameter '#{param}' missing!" if opts[param].nil?
      end
    end

    def translate_booleans(opts)
      opts.transform_values do |v|
        case v
        when true then 'on'
        when false then 'off'
        else v
        end
      end
    end

    def translate_values(opts, params)
      opts.map do |k, v|
        [
          k,
          params.include?(k) ? const_lookup(k, v) : v
        ]
      end.to_h
    end

    def const_lookup(type, key)
      Const::CONSTS[type].fetch(key) do
        raise ArgumentError, "#{key} is not a valid value for #{type}"
      end
    end

    # Some API calls require expiration dates.
    # The default is to not expire campaigns/offers/etc., so we set this to far in the future.
    # It cannot be *that* far in the future though because it causes a datetime overflow
    # in the steam powered rusty black box they call a database server.
    def future_expiration_date
      Date.current + (365 * 30)
    end
  end
end
