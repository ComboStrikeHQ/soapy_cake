# frozen_string_literal: true

RSpec.describe SoapyCake::Client do
  subject(:client) { described_class.new }

  let(:http) do
    instance_double(Net::HTTP)
  end

  let(:request) do
    SoapyCake::Request.new(:admin, :addedit, :advertiser, {})
  end

  describe '#run' do
    context 'receives non-200 HTTP status code' do
      before do
        stub_request(:post, "https://#{ENV.fetch('CAKE_DOMAIN')}/api/1/addedit.asmx")
          .to_return(status: 500, body: '🔥')
      end

      it 'raises an exception with request information' do
        expect do
          client.run(request)
        end.to raise_error(SoapyCake::RequestFailed, 'Request failed with HTTP 500') do |e|
          expect(e.request_path).to eq('/api/1/addedit.asmx')
          expect(e.request_body).to include('<cake:api_key>[redacted]</cake:api_key>')
          expect(e.response_body).to eq('🔥')
        end
      end
    end

    context 'receives 200 HTTP status code with errors' do
      before do
        stub_request(:post, "https://#{ENV.fetch('CAKE_DOMAIN')}/api/1/addedit.asmx")
          .to_return(status: 200, body: '🔥')
      end

      it 'raises an exception with request information' do
        expect do
          client.run(request)
        end.to raise_error(SoapyCake::RequestFailed, 'Unknown error') do |e|
          expect(e.request_path).to eq('/api/1/addedit.asmx')
          expect(e.request_body).to include('<cake:api_key>[redacted]</cake:api_key>')
          expect(e.response_body).to eq('🔥')
        end
      end
    end
  end
end
