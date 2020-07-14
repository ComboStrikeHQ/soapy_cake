# frozen_string_literal: true

RSpec.describe SoapyCake::ExchangeRates::ExchangeRate do
  describe '==' do
    context 'when exchange rates are equal' do
      let(:exchange_rate) do
        described_class.new(
          base_currency: {
            currency_id: 1,
            currency_abbr: 'USD',
            currency_name: 'Dollar',
            currency_symbol: '$'
          },
          quote_currency: {
            currency_id: 2,
            currency_abbr: 'EUR',
            currency_name: 'Euro',
            currency_symbol: '€'
          },
          rate: 3
        )
      end

      let(:other_exchange_rate) do
        described_class.new(
          base_currency_id: 1,
          quote_currency_id: 2,
          rate: 3
        )
      end

      it 'returns true' do
        expect(exchange_rate).to eq(other_exchange_rate)
      end
    end

    context 'when exchange rates are equal' do
      let(:exchange_rate) do
        described_class.new(
          base_currency: {
            currency_id: 1,
            currency_abbr: 'USD',
            currency_name: 'Dollar',
            currency_symbol: '$'
          },
          quote_currency: {
            currency_id: 3,
            currency_abbr: 'RUB',
            currency_name: 'Rubel',
            currency_symbol: '₽'
          },
          rate: 3
        )
      end

      let(:other_exchange_rate) do
        described_class.new(
          base_currency_id: 1,
          quote_currency_id: 2,
          rate: 3
        )
      end

      it 'returns false' do
        expect(exchange_rate).not_to eq(other_exchange_rate)
      end
    end
  end
end
