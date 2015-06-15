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
      fail Error, "Parameter '#{key}' must be > 0!" if opts[key].to_i < 1
    end

    def require_params(opts, params)
      params.each do |param|
        fail Error, "Parameter '#{param}' missing!" unless opts.key?(param)
      end
    end

    def translate_booleans!(opts)
      opts.each do |k, v|
        opts[k] = 'on' if v == true
        opts[k] = 'off' if v == false
      end
    end

    def translate_values!(opts, params)
      params.each do |type|
        opts[type] = const_lookup(type, opts[type]) if opts.key?(type)
      end
    end

    def const_lookup(type, key)
      Const::CONSTS[type].fetch(key) do
        fail ArgumentError, "#{key} is not a valid value for #{type}"
      end
    end

    # Some API calls require expiration dates.
    # The default is to not expire campaigns/offers/etc., so we set this to far in the future.
    # It cannot be *that* far in the future though because it causes a datetime overflow
    # in the steam powered rusty black box they call a database server.
    def future_expiration_date
      Date.today + (365 * 30)
    end
  end
end
