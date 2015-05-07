require 'spec_helper'

RSpec.describe SoapyCake::AdminTrack do
  describe '#decrypt_affiliate_link' do
    let(:service) { :track }
    let(:cake_method) { :decrypt_affiliate_link }
    let(:method) { :decrypt_affiliate_link }
    let(:cake_opts) { { a: 1 } }

    it_behaves_like 'a cake admin method'
  end
end
