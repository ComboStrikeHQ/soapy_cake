# encoding: utf-8

require 'spec_helper'

describe SoapyCake::Client do
  before do
    SoapyCake::Client.instance_variable_set(:@client, nil)
  end

  describe '.new' do
    subject { SoapyCake::Client.new(opts) }

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
    # TODO: Takes parameters which we don't support, yet.
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
      subject { SoapyCake::Client.new.public_send(name) }

      around do |example|
        VCR.use_cassette(:"client_new_#{name}", &example)
      end

      it { should include(exp_sample) }
    end
  end

  describe '#remove_prefixes' do
    it 'removes prefix from hash keys' do
      expect(
        SoapyCake::Client.new.
          send(:remove_prefix, 'foo', { foo_id: 'bar', foo_name: 'baz' })
      ).to eq({ id: 'bar', name: 'baz' })
    end
  end
end
