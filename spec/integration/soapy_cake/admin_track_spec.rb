require 'spec_helper'

RSpec.describe SoapyCake::AdminTrack do
  describe '#decrypt_affiliate_link' do
    let(:service) { :track }
    let(:cake_method) { :decrypt_affiliate_link }
    let(:method) { :decrypt_affiliate_link }
    let(:cake_opts) { { a: 1 } }

    it_behaves_like 'a cake admin method'
  end

  describe '#mass_conversion_insert', :vcr do
    it 'insers conversions' do
      result = subject.mass_conversion_insert(
        conversion_date: Date.new(2015, 5, 6),
        affiliate_id: 16059,
        campaign_id: 13268,
        sub_affiliate: '',
        creative_id: 5521,
        total_to_insert: 12
      )

      expect(result).to eq(success: true, message: 'Conversions Inserted')
    end
  end
end
