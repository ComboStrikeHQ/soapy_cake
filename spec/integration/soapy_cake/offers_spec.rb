# frozen_string_literal: true
RSpec.describe SoapyCake::Offers, :vcr do
  subject(:client) { described_class.new }

  let(:offer_id) { 11390 }

  describe '#get' do
    it 'gets offers' do
      offers = client.get(offer_id: offer_id)
      expect(offers.first.fetch(:offer_id)).to eq(offer_id)
    end
  end

  describe '#create' do
    it 'creates an offer' do
      offer_id = client.create(
        offer_type_id: 1,
        offer_name: 'Soapy Cake Test Offer',
        offer_status_id: 1,
        offer_link: 'http://example.com',
        payout: 1.23,
        received: 0.9,
        advertiser_id: 1,
        currency_id: 1,
        price_format_id: 1,
      )
      expect(offer_id).to be_a(Integer)
    end

    it 'raises an error if the creation was unsuccessful' do
      expect do
        client.create
      end.to raise_error(SoapyCake::RequestFailed, 'Invalid Payout Modification Type')
    end
  end

  describe '#update' do
    it 'updates offers' do
      response = client.update(
        offer_id,
        advertiser_id: 1,
        allowed_media_type_ids: '1',
        allowed_media_type_modification_type: 'replace',
        auto_disposition_delay_hours: 0,
        cookie_domain: 'trk_ad2games.cakemarketing.com',
        currency_id: 1,
        offer_contract_hidden: false,
        offer_type_id: 1,
        postback_url_ms_delay: 0,
        price_format_id: 1,
        received_percentage: true,
        redirect_domain: 'example.com',
        tags: 'foo,bar',
        tags_modification_type: 'replace',
        payout: 1.23,
        received: 0.9
      )
      expect(response).to be(nil)
    end

    it 'raises an error if the update was unsuccessful' do
      expect do
        client.update(
          offer_id,
          advertiser_id: 1,
          allowed_media_type_ids: '99999',
          allowed_media_type_modification_type: 'replace',
          auto_disposition_delay_hours: 0,
          cookie_domain: 'trk_ad2games.cakemarketing.com',
          currency_id: 1,
          offer_contract_hidden: false,
          offer_type_id: 1,
          postback_url_ms_delay: 0,
          price_format_id: 1,
          received_percentage: true,
          redirect_domain: 'example.com',
          tags: 'foo,bar',
          tags_modification_type: 'replace',
          payout: 1.23,
          received: 0.9
        )
      end.to raise_error(SoapyCake::RequestFailed, 'Invalid Media Type ID')
    end
  end

  describe '#patch' do
    it 'patches an offer' do
      %w(foo bar).each do |name|
        client.patch(offer_id, offer_name: name)
        offer = client.get(offer_id: offer_id).first
        expect(offer.fetch(:offer_name)).to eq(name)
      end
    end

    context 'different pre-existing values' do
      let(:attribute_sets) do
        {
          advertiser_extended_terms: nil,
          advertiser_id: 1,
          allow_affiliates_to_create_creatives: true,
          allowed_media_type_ids: '1,2',
          allowed_media_type_modification_type: 'replace',
          auto_disposition_delay_hours: 1,
          auto_disposition_type: 'rejected',
          click_cookie_days: 0,
          click_trumps_impression: true,
          conversion_behavior_on_redirect: 1,
          conversion_cap_behavior: 1,
          conversions_from_whitelist_only: true,
          currency_id: 1,
          disable_click_deduplication: true,
          enable_transaction_id_deduplication: true,
          enable_view_thru_conversions: true,
          expiration_date: Time.utc(2016, 12, 2),
          expiration_date_modification_type: 'remove',
          fire_global_pixel: true,
          fire_pixel_on_nonpaid_conversions: true,
          from_lines: 'Max Mustermann <max@ad2games.com>',
          hidden: true,
          impression_cookie_days: 1,
          last_touch: true,
          offer_contract_hidden: true,
          offer_contract_name: 'Awesome Name',
          offer_description: nil,
          offer_id: offer_id,
          offer_link: 'http://example.com/offer',
          offer_name: 'Awesome Offer',
          offer_status_id: 1,
          offer_type_id: 1,
          payout: 1.23,
          payout_modification_type: 'change',
          pixel_html: '<pixel>',
          postbacks_only: true,
          postback_url: 'http://example.com/postback',
          postback_url_ms_delay: 1,
          preview_link: 'http://example.com/preview',
          price_format_id: 1,
          received: 0.9,
          received_percentage: true,
          received_modification_type: 'change',
          redirect_404: true,
          redirect_domain: 'http://example.com/redirect',
          redirect_offer_contract_id: ,
          restrictions: ,
          session_regeneration_seconds: ,
          session_regeneration_type_id: ,
          ssl: ,
          static_suppression: ,
          subject_lines: ,
          tags: ,
          tags_modification_type: ,
          testing_instructions: ,
          thankyou_link: ,
          third_party_name: ,
          thumbnail_file_import_url: ,
          track_search_terms_from_non_supported_search_engines: ,
          unsubscribe_link: ,
          vertical_id: ,
        }
      end
    end
  end
end
