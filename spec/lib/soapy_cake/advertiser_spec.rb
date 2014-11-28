require 'spec_helper'

RSpec.describe SoapyCake::Advertiser do
  subject { described_class.new(api_key: 'abc', advertiser_id: 1) }

  describe '.bills' do
    it 'returns bills for an advertiser' do
      expect_any_instance_of(SoapyCake::Client::CakeClient).to receive(:bills)
        .with(advertiser_id: 1, api_key: 'abc')

      subject.bills
    end
  end
end
