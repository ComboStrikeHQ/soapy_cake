# frozen_string_literal: true

module SoapyCake
  class ExchangeRates
    def get(start_date:, end_date:)
      client.run(
        Request.new(
          :admin,
          :get,
          :exchange_rates,
          start_date: start_date,
          end_date: end_date
        )
      ).map(&ExchangeRate.method(:new))
    end

    def upsert(start_date:, end_date:, exchange_rates:)
      client.run(
        Request.new(
          :admin,
          :addedit,
          :exchange_rate,
          start_date: start_date,
          end_date: end_date,
          exchange_rates: exchange_rates.map(&:to_xml_structure)
        )
      )
    end

    class ExchangeRate
      def initialize(opts)
        if opts.key?(:base_currency_id)
          @base_currency_id = opts[:base_currency_id]
        else
          @base_currency = Currency.new(opts.fetch(:base_currency))
        end

        if opts.key?(:quote_currency_id)
          @quote_currency_id = opts[:quote_currency_id]
        else
          @quote_currency = Currency.new(opts.fetch(:quote_currency))
        end

        @rate = opts.fetch(:rate)
        @start_date = opts[:start_date]
        @end_date = opts[:end_date]
      end

      attr_reader :base_currency, :quote_currency, :rate, :start_date, :end_date

      def base_currency_id
        @base_currency_id || @base_currency_id.fetch(:currency_id)
      end

      def quote_currency_id
        @quote_currency_id || @quote_currency_id.fetch(:currency_id)
      end

      def to_xml_structure
        {
          exchange_rate: {
            base_currency_id: base_currency_id,
            quote_currency_id: quote_currency_id,
            rate: rate
          }
        }
      end

      def ==(other_exchange_rate)
        (
          base_currency == other_exchange_rate.base_currency ||
            base_currency_id == other_exchange_rate.base_currency_id
        ) && (
          quote_currency == other_exchange_rate.quote_currency ||
            quote_currency_id == other_exchange_rate.quote_currency_id
        ) &&
          rate == other_exchange_rate.rate &&
          start_date == other_exchange_rate.start_date &&
          end_date == other_exchange_rate.end_date
      end
    end

    class Currency
      def initialize(currency_abbr:, currency_id:, currency_name: , currency_symbol:)
        @currency_abbr = currency_abbr
        @currency_id = currency_id
        @currency_name = currency_name
        @currency_symbol = currency_symbol
      end

      attr_reader :currency_abbr, :currency_id, :currency_name, :currency_symbol

      def ==(other_currency)
        %i[currency_abbr currency_id currency_name currency_symbol]
          .map { |attr| public_send(attr) == other_currency.public_send(attr) }
          .reduce { |a, b| a && b }
      end
    end

    private

    def client
      @client ||= Client.new
    end
  end
end
