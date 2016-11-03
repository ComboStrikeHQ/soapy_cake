# frozen_string_literal: true
RSpec.describe SoapyCake::Campaigns, :vcr do
  let(:offer_id) { 11390 }

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
        affiliate_id: 9643,
        offer_id: offer_id,
        clear_session_on_conversion: 'on',
        currency_id: 1,
        display_link_type_id: 1,
        expiration_date: Date.new(1970, 1, 1),
        media_type_id: 1,
        paid: 'on',
        paid_redirects: 'off',
        paid_upsells: 'on',
        payout: 1.23,
        pixel_html: '<img src="https://example.com/pixel.png">',
        postback_url: 'http://example.com/postback',
        redirect_404: 'off',
        redirect_domain: 'trk_ad2games.cakemarketing.net',
        review: 'off',
        test_link: 'http://example.com/test',
        unique_key_hash: 'sha1',
        redirect_offer_contract_id: 0,
        use_offer_contract_payout: 'on'
      )
      expect(campaign_id).to be_a(Integer)
    end

    it 'raises an error if the creation was unsuccessful' do
      expect do
        client.create(
          account_status_id: 1,
          affiliate_id: 0,
          offer_id: offer_id,
          clear_session_on_conversion: 'on',
          currency_id: 1,
          display_link_type_id: 1,
          expiration_date: Date.new(1970, 1, 1),
          media_type_id: 1,
          paid: 'on',
          paid_redirects: 'off',
          paid_upsells: 'on',
          payout: 1.23,
          pixel_html: '<img src="https://example.com/pixel.png">',
          postback_url: 'http://example.com/postback',
          redirect_404: 'off',
          redirect_domain: 'trk_ad2games.cakemarketing.net',
          review: 'off',
          test_link: 'http://example.com/test',
          unique_key_hash: 'sha1',
          redirect_offer_contract_id: 0,
          use_offer_contract_payout: 'on'
        )
      end.to raise_error(SoapyCake::RequestFailed, 'Invalid Affiliate')
    end
  end

  describe '#update' do
    it 'updated campaigns' do
      response = client.update(
        23602,
        affiliate_id: 9643,
        display_link_type_id: 1,
        media_type_id: 1,
        offer_contract_id: 10338,
        offer_id: 11390,
        payout: 1.23,
        pixel_html: '<img src="https://example.com/pixel.png">',
        postback_url: 'http://example.com/postback',
        redirect_domain: 'trk_ad2games.cakemarketing.net',
        test_link: 'http://example.com/test',
        unique_key_hash: 'sha1'
      )
      expect(response).to be(nil)
    end

    it 'raises an error if the update was unsuccessful' do
      expect do
        client.update(
          9999999,
          affiliate_id: 9643,
          display_link_type_id: 1,
          media_type_id: 1,
          offer_contract_id: 10338,
          offer_id: 11390,
          payout: 1.23,
          pixel_html: '<img src="https://example.com/pixel.png">',
          postback_url: 'http://example.com/postback',
          redirect_domain: 'trk_ad2games.cakemarketing.net',
          test_link: 'http://example.com/test',
          unique_key_hash: 'sha1'
        )
      end.to raise_error(SoapyCake::RequestFailed, 'Invalid Campaign ID')
    end
  end
end
