# encoding: utf-8

require 'spec_helper'

RSpec.describe SoapyCake::Client::CakeClient do
  before do
    described_class.instance_variable_set(:@sekken_clients, nil)
  end

  subject(:client) { described_class.new(:get, opts) }
  let(:opts) { {} }

  describe '.new' do
    context 'when passed api key' do
      let(:opts) { { api_key: 'api-key' } }

      around { |example| VCR.use_cassette(:client_new_with_api_key, &example) }

      describe '#api_key' do
        subject { super().api_key }
        it { is_expected.to eq('api-key') }
      end
    end

    context 'when passed username and password' do
      let(:opts) { { username: 'username', password: 'password' } }

      around do |example|
        VCR.use_cassette(:client_new_with_username_and_password, &example)
      end

      describe '#api_key' do
        subject { super().api_key }
        it { is_expected.to eq('api-key') }
      end
    end
  end

  {
    account_statuses: { id: '1', name: 'Active' },
    advertisers: { id: '1', name: 'ad2games GmbH' },
    affiliate_tags: { id: '1', name: 'Suspicious' },
    affiliate_tiers: { id: '1', name: 'Tier 1' },
    billing_cycles: { id: '1', name: 'Weekly' },
    cap_intervals: { id: '1', name: 'Daily' },
    cap_types: { id: '1', name: 'Click' },
    countries: { code: 'DE', name: 'Germany' },
    currencies: { id: '1', symbol: '€', name: 'Euro', abbr: 'EUR' },
    # TODO: Let's test this when there is data.
    # departments: [],
    # TODO: We don't get any exchange rates from the test API. Fill in when we
    # have real API access.
    # exchange_rates: {},
    languages: { id: '1', name: 'ENGLISH', abbr: 'en' },
    offer_statuses: { id: '3', name: 'Apply To Run' },
    offer_types: { id: '3', name: '3rd Party' },
    payment_settings: { id: '1', name: 'Pay affiliate in system default currency' },
    payment_types: { id: '1', name: 'Check' },
    price_formats: { id: '1', name: 'CPA' },
    roles: { id: '3', name: 'Account Manager', entity_type_id: nil, entity_type_name: 'Employee' },
    verticals: { id: '-1', name: 'Global' },
  }.each do |name, exp_sample|
    describe "##{name}" do
      subject { client.public_send(name) }

      around do |example|
        VCR.use_cassette(:"client_new_#{name}", &example)
      end

      it { is_expected.to include(exp_sample) }
    end
  end

  describe 'an empty response' do
    context 'for exchange rates' do
      subject do
        client.exchange_rates(
          start_date: Time.parse('2013-01-01 00:00:00 +0000)'),
          end_date: Date.parse('2013-01-31')
        )
      end

      around do |example|
        VCR.use_cassette(:client_new_empty_response, &example)
      end

      it { is_expected.to eq([]) }
    end

    context 'for offer summary' do
      subject do
        described_class.new(:reports, opts).offer_summary(
          start_date: Time.utc(2013, 1, 1),
          end_date: Time.utc(2013, 1, 2)
        )
      end

      around do |example|
        VCR.use_cassette(:client_new_empty_response_offer_summary, &example)
      end

      it { is_expected.to eq([]) }
    end
  end

  describe '#remove_prefixes' do
    it 'removes prefix from hash keys' do
      expect(
        client.send(:remove_prefix, 'foo', foo_id: 'bar', foo_name: 'baz')
      ).to eq(id: 'bar', name: 'baz')
    end
  end

  describe '#sekken_client' do
    around do |example|
      VCR.use_cassette(:"client_sekken_client_caches_results", &example)
    end

    it 'results are cached' do
      expect(client.sekken_client('roles')).to equal(client.sekken_client('roles'))
    end

    context 'for different methods with the same wsdl url' do
      it 'results are cached' do
        expect(client.sekken_client('roles')).to equal(client.sekken_client('advertisers'))
      end
    end
  end

  describe '#not_a_valid_method' do
    subject { -> { client.send('not_a_valid_method') } }

    context 'when an unsupported method is called' do
      it { is_expected.to raise_error }
    end
  end

  describe '#process_response' do
    let(:response) do
      {
        affiliate_response: {
          affiliate_result: {
            success: true,
            message: 'Affiliate Added Successfully',
            affiliate_id: '16103',
            tipalti_iframe_expiration_date: nil,
          }
        }
      }
    end

    let(:get_response) do
      {
        get_campaign_response: {
          get_campaign_result: {
            success: true,
            campaign: {
              offer_id: '5129'
            }
          }
        }
      }
    end

    it 'handles responses with a message field as not having a collection' do
      expect(client.send(:process_response, :affiliate, response)).to eq(
        response[:affiliate_response][:affiliate_result])
    end

    it 'handles get API responses as having no collection' do
      expect(client.send(:process_response, :get_campaign, get_response)).to eq(
        get_response[:get_campaign_response][:get_campaign_result])
    end

    it 'raises RequestUnsuccessful if response contains success: false' do
      expect do
        client.send(:process_response, :affiliate, affiliate_response: {
                      affiliate_result: { message: 'FAIL!', success: false }
                    })
      end.to raise_error(described_class::RequestUnsuccessful, 'FAIL!')
    end

    it 'raises RequestUnsuccessful if response contains `:fault` key' do
      expect do
        client.send(:process_response, :affiliate,
                    fault: { reason: { text: 'FAIL!' } })
      end.to raise_error(described_class::RequestUnsuccessful, 'FAIL!')
    end
  end

  describe 'instantiating through class method' do
    it 'creates an instance with the service set according to the method name used' do
      instance = described_class.get
      expect(instance.service).to eq(:get)
    end
  end
end