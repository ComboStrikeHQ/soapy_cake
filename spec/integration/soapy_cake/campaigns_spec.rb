# frozen_string_literal: true
RSpec.describe SoapyCake::Campaigns, :vcr do
  let(:offer_id) { 11390 }
  let(:affiliate_id) { 9643 }
  let(:redirect_domain) { 'trk_ad2games.cakemarketing.net' }

  subject(:client) { described_class.new }

  describe '#get' do
    it 'gets campaigns' do
      campaigns = client.get(offer_id: offer_id)
      expect(campaigns.first.dig(:offer, :offer_id)).to eq(offer_id)
    end
  end

  describe '#create' do
    it 'creates campaigns' do
      campaign_id = client.create(
        account_status_id: 1,
        affiliate_id: affiliate_id,
        display_link_type_id: 1,
        media_type_id: 1,
        offer_id: offer_id
      )
      expect(campaign_id).to be_a(Integer)
    end

    it 'raises an error if the creation was unsuccessful' do
      expect do
        client.create(
          account_status_id: 1,
          affiliate_id: 0,
          display_link_type_id: 1,
          media_type_id: 1,
          offer_id: offer_id
        )
      end.to raise_error(SoapyCake::RequestFailed, 'Invalid Affiliate')
    end
  end

  describe '#update' do
    it 'updated campaigns' do
      response = client.update(
        23602,
        affiliate_id: affiliate_id,
        display_link_type_id: 1,
        media_type_id: 1,
        offer_contract_id: 10338,
        offer_id: 11390,
        payout: 1.23,
        pixel_html: '<img src="https://example.com/pixel.png">',
        postback_url: 'http://example.com/postback',
        redirect_domain: redirect_domain,
        test_link: 'http://example.com/test',
        third_party_name: 'Max',
        unique_key_hash: 'sha1'
      )
      expect(response).to be(nil)
    end

    it 'raises an error if the update was unsuccessful' do
      expect do
        client.update(
          9999999,
          affiliate_id: affiliate_id,
          display_link_type_id: 1,
          media_type_id: 1,
          offer_contract_id: 10338,
          offer_id: 11390,
          payout: 1.23,
          pixel_html: '<img src="https://example.com/pixel.png">',
          postback_url: 'http://example.com/postback',
          redirect_domain: redirect_domain,
          test_link: 'http://example.com/test',
          third_party_name: 'Max',
          unique_key_hash: 'sha1'
        )
      end.to raise_error(SoapyCake::RequestFailed, 'Invalid Campaign ID')
    end
  end

  describe '#patch' do
    let(:admin) { SoapyCake::Admin.new }

    it 'updates a campaign without params provided' do
      client.patch(23733)
    end
  end
end
