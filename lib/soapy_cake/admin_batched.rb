module SoapyCake
  class AdminBatched
    ALLOWED_METHODS = %i(
      advertisers affiliates campaigns offers creatives clicks conversions events
    )

    class BatchedRequest
      # Both 0 and 1 return the first element. We need to set it to 1,
      # otherwise we get an overlap in the next call. This is not documented in the API spec.
      INITIAL_OFFSET = 1

      # This value depends on the entity size.
      # When all offers have a lot of info (e.g. geotargeting) we probably need to decrease this.
      LIMIT = 500

      def initialize(admin, method, opts, limit)
        if opts.key?(:row_limit) || opts.key?(:start_at_row)
          fail Error, 'Cannot set row_limit/start_at_row in batched mode!'
        end

        @admin = admin
        @method = method
        @opts = opts
        @offset = INITIAL_OFFSET
        @limit = limit || LIMIT
      end

      def to_enum
        Enumerator.new do |y|
          loop do
            result = next_batch
            @offset += limit
            limit.times { y << result.next }
          end
        end
        # we know we received less than limit objects when we see a stop iteration exception from
        # the underlying result enumerator and therefore know that we're done.
      rescue StopIteration # rubocop:disable Lint/HandleExceptions
      end

      private

      def next_batch
        admin.public_send(method, opts.merge(row_limit: limit, start_at_row: offset))
      end

      attr_reader :admin, :method, :opts, :offset, :limit
    end

    def method_missing(name, opts = {}, limit = nil)
      fail Error, "Invalid method #{name}" unless ALLOWED_METHODS.include?(name)

      BatchedRequest.new(admin, name, opts, limit).to_enum
    end

    private

    def admin
      @admin ||= Admin.new
    end
  end
end
