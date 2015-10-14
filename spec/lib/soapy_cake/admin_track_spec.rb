require 'spec_helper'

RSpec.describe SoapyCake::AdminTrack do
  describe '#decrypt_affiliate_link' do
    let(:service) { :track }
    let(:cake_method) { :decrypt_affiliate_link }
    let(:method) { :decrypt_affiliate_link }
    let(:cake_opts) { { a: 1 } }
    let(:opts) { nil }

    it_behaves_like 'a cake admin method'
  end

  describe '#update_conversion' do
    let(:service) { :track }
    let(:cake_method) { :update_conversion }
    let(:method) { :update_conversion }
    let(:cake_opts) { described_class::CONVERSION_DEFAULTS.merge(opts) }
    let(:opts) { { offer_id: 42, payout: 0 } }

    it_behaves_like 'a cake admin method'
  end
end
