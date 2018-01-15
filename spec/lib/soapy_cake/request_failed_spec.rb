# frozen_string_literal: true

RSpec.describe SoapyCake::RequestFailed do
  it 'has request related attributes' do
    error = described_class.new(
      'Boo!',
      request_path: 'request path',
      request_body: 'request body',
      response_body: 'response body'
    )
    expect(error).to have_attributes(
      'request_path' => 'request path',
      'request_body' => 'request body',
      'response_body' => 'response body'
    )
  end

  it 'redacts the API key from the request body' do
    error = described_class.new('Boo!', request_body: ">#{ENV.fetch('CAKE_API_KEY')}<")
    expect(error.request_body).to eq('>[redacted]<')
  end
end
