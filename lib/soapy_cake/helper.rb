module SoapyCake
  module Helper
    def self.walk_tree(obj, key = nil, &block)
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
  end
end
