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
    before do
      allow(Net::HTTP)
        .to receive(:start)
        .and_yield(http)
      allow(http)
        .to receive(:request)
        .and_return(response)
    end

    context 'receives non-200 HTTP status code' do
      let(:response) do
        instance_double(Net::HTTPInternalServerError, code: 500, body: '🔥')
      end

      it 'raises an exception with request information' do
        expect(response).to receive(:is_a?).with(Net::HTTPSuccess).and_return(false)

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
      let(:response) do
        instance_double(Net::HTTPSuccess, code: 200, body: '🔥')
      end

      it 'raises an exception with request information' do
        expect(response).to receive(:is_a?).with(Net::HTTPSuccess).and_return(true)

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
