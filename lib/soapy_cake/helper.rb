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
  end
end
