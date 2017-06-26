# frozen_string_literal: true

RSpec.shared_examples_for 'a cake admin method' do
  subject(:admin) { described_class.new }

  let(:request) { instance_double(SoapyCake::Request) }

  it 'runs the request' do
    expect(SoapyCake::Request).to receive(:new)
      .with(:admin, service, cake_method, cake_opts || {}).and_return(request)
    expect(admin).to receive(:run).with(request)

    admin.public_send(method, *[opts || cake_opts].compact)
  end
end
