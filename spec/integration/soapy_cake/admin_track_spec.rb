# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SoapyCake::AdminTrack do
  subject(:admin_track) { described_class.new }

  describe '#mass_conversion_insert', :vcr do
    it 'inserts conversions' do
      result = admin_track.mass_conversion_insert(
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

  describe '#update_conversion', :vcr do
    it 'updates a conversion' do
      result = admin_track.update_conversion(
        conversion_id: 145211,
        offer_id: 5032,
        payout: 0.75,
        received: 1.75
      )

      expect(result).to eq(success: true, message: 'Conversion Updated')
    end
  end
end
