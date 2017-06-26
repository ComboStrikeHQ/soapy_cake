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
    it 'updates campaigns' do
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
    let(:campaign_id) { 23733 }

    it 'updates a campaign' do
      %w[foo bar].each do |name|
        client.patch(campaign_id, third_party_name: name)
        campaign = client.get(campaign_id: campaign_id).first
        expect(campaign.fetch(:third_party_name)).to eq(name)
      end
    end

    context 'different pre-existing values' do
      let(:attribute_sets) do
        [
          {
            affiliate_id: affiliate_id,
            campaign_id: campaign_id,
            offer_id: offer_id,

            account_status_id: 1,
            auto_disposition_delay_hours: 0,
            clear_session_on_conversion: true,
            currency_id: 1,
            display_link_type_id: 1,
            expiration_date: Time.utc(2016, 11, 9),
            expiration_date_modification_type: 'change',
            media_type_id: 1,
            offer_contract_id: 10338,
            paid: true,
            paid_redirects: true,
            paid_upsells: true,
            payout: 0,
            payout_update_option: 'remove',
            pixel_html: '',
            postback_delay_ms: -1,
            postback_url: '',
            redirect_404: true,
            redirect_domain: redirect_domain,
            redirect_offer_contract_id: 10337,
            review: true,
            test_link: '',
            unique_key_hash: 'none',
            use_offer_contract_payout: true,
            third_party_name: ''
          },
          {
            affiliate_id: affiliate_id,
            campaign_id: campaign_id,
            offer_id: offer_id,

            account_status_id: 2,
            auto_disposition_delay_hours: 1,
            clear_session_on_conversion: false,
            currency_id: 2,
            display_link_type_id: 1,
            expiration_date: Time.utc(1970, 1, 1),
            expiration_date_modification_type: 'remove',
            media_type_id: 2,
            offer_contract_id: 10342,
            paid: false,
            paid_redirects: false,
            paid_upsells: false,
            payout: 1,
            payout_update_option: 'change',
            pixel_html: 'pixelpixelpixel',
            postback_delay_ms: 100,
            postback_url: 'https://example.com/postback',
            redirect_404: false,
            redirect_domain: redirect_domain,
            redirect_offer_contract_id: 10339,
            review: false,
            test_link: 'https://example.com/test',
            unique_key_hash: 'sha1',
            use_offer_contract_payout: false,
            third_party_name: 'Best Campaign Ever'
          }
        ]
      end

      2.times do |i|
        it "does not change anything unintentionally (attribute set: #{i})" do
          client.update(campaign_id, attribute_sets[i])

          campaign_before = client.get(campaign_id: campaign_id).first
          client.patch(campaign_id)
          campaign_after = client.get(campaign_id: campaign_id).first

          expect(campaign_after).to eq(campaign_before)
        end
      end
    end
  end
end
