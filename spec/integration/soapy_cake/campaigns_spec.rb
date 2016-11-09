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

    generative do
      data(:params) do
        {
          account_status_id: admin.account_statuses.map { |s| s.fetch(:account_status_id) }.sample,
          affiliate_id: affiliate_id,
          auto_disposition_delay_hours: rand(24),
          campaign_id: campaign_id,
          clear_session_on_conversion: %w(on off).sample,
          currency_id: admin.currencies.map { |s| s.fetch(:currency_id) }.sample,
          display_link_type_id: 1,
          expiration_date: Time.current,
          expiration_date_modification_type: %w(change remove).sample,
          media_type_id: admin.media_types.map { |s| s.fetch(:media_type_id) }.sample,
          offer_contract_id: [10338, 10342, 10343, 10344].sample,
          offer_id: offer_id,
          paid: %w(on off).sample,
          paid_redirects: %w(on off).sample,
          paid_upsells: %w(on off).sample,
          payout: rand * 3,
          payout_update_option: %w(change remove).sample,
          pixel_html: ['', 'pixel'].sample,
          postback_delay_ms: [-1, rand(1000)].sample,
          postback_url: ['', 'https://example.com/postback'].sample,
          redirect_404: %w(on off).sample,
          redirect_domain: redirect_domain,
          redirect_offer_contract_id: [10337, 10339, 10340, 10341].sample,
          review: %w(on off).sample,
          test_link: ['', 'https://example.com/test'].sample,
          unique_key_hash: %w(none sha1 md5 sha1_with_base64 md5_with_base64).sample,
          use_offer_contract_payout: %w(on off).sample,
          third_party_name: ['', 'Max', 'Peter', 'Oleg'].sample
        }
      end

      let(:campaign_id) { 23733 }

      it 'does not change anything unintentionally' do
        client.update(campaign_id, params)

        campaign_before = client.get(campaign_id: campaign_id).first
        client.patch(campaign_id)
        campaign_after = client.get(campaign_id: campaign_id).first

        expect(campaign_after).to eq(campaign_before)
      end
    end
  end
end
