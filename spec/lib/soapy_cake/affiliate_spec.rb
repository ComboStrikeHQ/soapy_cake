# frozen_string_literal: true
RSpec.describe SoapyCake::Affiliate do
  let(:affiliate_id) { 42 }
  let(:opts) { { a: 1 } }
  let(:cake_opts) { opts.merge(affiliate_id: affiliate_id) }

  subject { described_class.new(affiliate_id: affiliate_id) }

  shared_examples_for 'a cake affiliate method' do
    it 'runs the request' do
      request = instance_double(SoapyCake::Request)
      expect(SoapyCake::Request).to receive(:new)
        .with(:affiliate, service, method, cake_opts).and_return(request)
      expect(subject).to receive(:run).with(request)

      subject.public_send(method, opts)
    end
  end

  describe '#bills' do
    let(:service) { :reports }
    let(:method) { :bills }
    it_behaves_like 'a cake affiliate method'
  end

  describe '#offer_feed' do
    let(:service) { :offers }
    let(:method) { :offer_feed }
    it_behaves_like 'a cake affiliate method'
  end
end
