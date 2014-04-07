# encoding: utf-8

require 'spec_helper'

describe SoapyCake::Client do
  before do
    SoapyCake::Client.instance_variable_set(:@savon_clients, nil)
  end

  describe '.new' do
    subject { SoapyCake::Client.new(:get, opts) }

    context 'when passed api key' do
      let(:opts) {{ api_key: 'api-key' }}

      around {|example| VCR.use_cassette(:client_new_with_api_key, &example) }

      its(:api_key) { should eq('api-key') }
    end

    context 'when passed username and password' do
      let(:opts) {{ username: 'username', password: 'password' }}

      around do |example|
        VCR.use_cassette(:client_new_with_username_and_password, &example)
      end

      its(:api_key) { should eq('api-key') }
    end
  end

  {
    account_statuses: { id: '1', name: 'Active' },
    advertisers: { id: '1', name: 'ad2games GmbH' },
    affiliate_tags: { id: '1', name: 'Suspicious'},
    affiliate_tiers: { id: '1', name: 'Tier 1'},
    billing_cycles: { id: '1', name: 'Weekly'},
    cap_intervals: { id: '1', name: 'Daily'},
    cap_types: { id: '1', name: 'Click'},
    countries: { code: 'DE', name: 'Germany'},
    currencies: { id: '1', symbol: '€', name: 'Euro', abbr: 'EUR' },
    # TODO: Let's test this when there is data.
    #departments: [],
    # TODO: We don't get any exchange rates from the test API. Fill in when we
    # have real API access.
    #exchange_rates: {},
    languages: { id: '1', name: 'ENGLISH', abbr: 'en' },
    media_types: { id: '15', name: 'Adware' },
    offer_statuses: { id: '3', name: 'Apply To Run' },
    offer_types: { id: '3', name: '3rd Party' },
    payment_settings: { id: '1', name: 'Pay affiliate in system default currency' },
    payment_types: { id: '1', name: 'Check' },
    price_formats: { id: '1', name: 'CPA' },
    roles: { id: '3', name: 'Account Manager', entity_type_id: nil, entity_type_name: 'Employee' },
    verticals: { id: '-1', name: 'Global' },
  }.each do |name, exp_sample|
    describe "##{name}" do
      subject { SoapyCake::Client.new(:get).public_send(name) }

      around do |example|
        VCR.use_cassette(:"client_new_#{name}", &example)
      end

      it { should include(exp_sample) }
    end
  end

  describe 'an empty response' do
    subject do
      SoapyCake::Client.new(:get).
        exchange_rates(start_date: '2013-01-01T00:00:00',
                       end_date: '2013-01-31T00:00:00')
    end

    around do |example|
      VCR.use_cassette(:client_new_empty_response, &example)
    end

    it { should eq([]) }
  end

  describe '#remove_prefixes' do
    it 'removes prefix from hash keys' do
      expect(
        SoapyCake::Client.new(:get).
          send(:remove_prefix, 'foo', { foo_id: 'bar', foo_name: 'baz' })
      ).to eq({ id: 'bar', name: 'baz' })
    end
  end

  describe '#savon_client' do
    let(:client) { SoapyCake::Client.new(:get) }

    around do |example|
      VCR.use_cassette(:"client_savon_client_caches_results", &example)
    end

    it 'results are cached' do
      expect(client.savon_client('roles')).to equal(client.savon_client('roles'))
    end

    context 'for different methods with the same wsdl url' do
      before do
        expect(client).to receive(:wsdl_url).twice.
          and_return("https://cake-partner-domain.com/api/1/get.asmx?WSDL")
      end

      it 'results are cached' do
        expect(client.savon_client('roles')).to equal(client.savon_client('advertisers'))
      end
    end
  end
end
