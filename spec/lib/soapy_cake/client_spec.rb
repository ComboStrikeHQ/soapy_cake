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
end
