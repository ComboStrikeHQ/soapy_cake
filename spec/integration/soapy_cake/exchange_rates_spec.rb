# frozen_string_literal: true

RSpec.describe SoapyCake::ExchangeRates, :vcr do
  subject(:exchange_rates) { described_class.new }

  describe '#get' do
    it 'returns exchange rates' do
      expect(
        exchange_rates.get(
          start_date: Date.new(2020, 7, 1),
          end_date: Date.new(2020, 7, 31)
        ).to_a
      ).to eq(
        [
          SoapyCake::ExchangeRates::ExchangeRate.new(
            base_currency: {
              currency_abbr: 'EUR',
              currency_id: 2,
              currency_name: 'Euro',
              currency_symbol: '€'
            },
            end_date: Time.utc(2020, 7, 31, 22),
            quote_currency: {
              currency_abbr: 'USD',
              currency_id: 1,
              currency_name: 'US Dollar',
              currency_symbol: '$'
            },
            rate: '1.1353212100',
            start_date: Time.utc(2020, 6, 30, 22)
          ),
          SoapyCake::ExchangeRates::ExchangeRate.new(
            base_currency: {
              currency_abbr: 'USD',
              currency_id: 1,
              currency_name: 'US Dollar',
              currency_symbol: '$'
            },
            end_date: Time.utc(2020, 7, 31, 22),
            quote_currency: {
              currency_abbr: 'EUR',
              currency_id: 2,
              currency_name: 'Euro',
              currency_symbol: '€'
            },
            rate: '0.8808080000',
            start_date: Time.utc(2020, 6, 30, 22)
          )
        ]
      )
    end
  end

  describe '#upsert' do
    it 'creates exchange rates in Cake' do
      expect(
        exchange_rates.upsert(
          start_date: Time.zone.local(2020, 7, 1),
          end_date: Time.zone.local(2020, 8, 1),
          exchange_rates: [
            SoapyCake::ExchangeRates::ExchangeRate.new(
              base_currency_id: 2,
              quote_currency_id: 1,
              rate: 1.13
            )
          ]
        )
      ).to eq(
        message: 'Exchange Rates Successfully Updated',
        success: true
      )
    end
  end
end
