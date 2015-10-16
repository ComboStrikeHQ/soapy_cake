module SoapyCake
  class AdminBatched
    ALLOWED_METHODS = %i(
      advertisers affiliates campaigns offers creatives clicks
      conversions events caps exchange_rates
    ).freeze

    def initialize(opts = {})
      @opts = opts.merge(batch_mode: true)
    end

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
        @fetched_rows = 0
      end

      def to_enum
        Enumerator.new do |y|
          loop do
            fetch_elements(y)
            @offset += limit
          end
          fail Error, 'Error not all rows fetched in batch mode' if @total_rows > @fetched_rows
        end
      end

      private

      def fetch_elements(enumerator)
        result = fetch_batch
        # raises StopIteration when less than `limit` elements are present
        # which is then rescued by `loop`
        if admin.xml_response?
          enumerator << result.next
        else
          limit.times { enumerator << result.next }
        end
      end

      def fetch_batch
        content, total, fetched = admin.public_send(method,
          opts.merge(row_limit: limit, start_at_row: offset))

        @total_rows ||= total
        @fetched_rows += fetched
        content
      end

      attr_reader :admin, :method, :opts, :offset, :limit
    end

    def method_missing(name, method_opts = {}, limit = nil)
      fail Error, "Invalid method #{name}" unless ALLOWED_METHODS.include?(name)
      BatchedRequest.new(admin, name, method_opts, limit).to_enum
    end

    private

    attr_reader :opts

    def admin
      @admin ||= Admin.new(opts)
    end
  end
end
