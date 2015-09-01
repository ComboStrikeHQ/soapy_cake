RSpec.shared_examples_for 'a cake admin method' do
  let(:request) { double('request') }

  it 'runs the request' do
    expect(SoapyCake::Request).to receive(:new)
      .with(:admin, service, cake_method, cake_opts || {}).and_return(request)
    expect(subject).to receive(:run).with(request)

    subject.public_send(method, *[cake_opts].compact)
  end
end
