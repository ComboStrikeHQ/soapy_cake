# frozen_string_literal: true
module SoapyCake
  class Offers
    include Helper

    # Does not include `cookie_domain`.
    ALL_PARAMS = %i(
      advertiser_extended_terms advertiser_id
      allow_affiliates_to_create_creatives allowed_media_type_ids
      allowed_media_type_modification_type auto_disposition_delay_hours
      auto_disposition_type click_cookie_days click_trumps_impression
      conversion_behavior_on_redirect conversion_cap_behavior
      conversions_from_whitelist_only currency_id
      disable_click_deduplication enable_transaction_id_deduplication
      enable_view_thru_conversions expiration_date
      expiration_date_modification_type fire_global_pixel
      fire_pixel_on_nonpaid_conversions from_lines hidden
      impression_cookie_days last_touch offer_contract_hidden
      offer_contract_name offer_description offer_id offer_link offer_name
      offer_status_id offer_type_id payout payout_modification_type pixel_html
      postbacks_only postback_url postback_url_ms_delay preview_link
      price_format_id received received_percentage received_modification_type
      redirect_404 redirect_domain redirect_offer_contract_id restrictions
      session_regeneration_seconds session_regeneration_type_id ssl
      static_suppression subject_lines tags tags_modification_type
      testing_instructions thankyou_link third_party_name
      thumbnail_file_import_url
      track_search_terms_from_non_supported_search_engines unsubscribe_link
      vertical_id
    ).freeze

    NO_CHANGE_VALUES = {
      vertical_id: 0,
      offer_name: '',
      third_party_name: '',
      hidden: 'no_change',
      offer_status_id: 0,
      ssl: 'no_change',
      click_cookie_days: -1,
      impression_cookie_days: -1,
      redirect_offer_contract_id: 0,
      redirect_404: 'no_change',
      enable_view_thru_conversions: 'no_change',
      click_trumps_impression: 'no_change',
      disable_click_deduplication: 'no_change',
      last_touch: 'no_change',
      enable_transaction_id_deduplication: 'no_change',
      postbacks_only: 'no_change',
      pixel_html: '',
      postback_url: '',
      fire_global_pixel: 'no_change',
      fire_pixel_on_nonpaid_conversions: 'no_change',
      static_suppression: -1,
      conversion_cap_behavior: -1,
      conversion_behavior_on_redirect: -1,
      offer_contract_name: '',
      offer_link: '',
      thankyou_link: '',
      preview_link: '',
      thumbnail_file_import_url: '',
      offer_description: '',
      restrictions: '',
      advertiser_extended_terms: '',
      testing_instructions: '',
      allow_affiliates_to_create_creatives: 'no_change',
      unsubscribe_link: '',
      from_lines: '',
      subject_lines: '',
      conversions_from_whitelist_only: 'no_change',
      track_search_terms_from_non_supported_search_engines: 'no_change',
      auto_disposition_type: 'no_change',
      session_regeneration_seconds: -1,
      session_regeneration_type_id: 0
    }.freeze

    delegate :read_only?, to: :client

    def get(opts = {})
      client.run Request.new(:admin, :export, :offers, opts)
    end

    def create(opts = {})
      opts = opts.merge(payout.options(opts))
      opts = opts.merge(received.options(opts))
      response = addedit_offer(opts.merge(offer_id: 0))
      response.fetch(:success_info).fetch(:offer_id)
    end

    def update(offer_id, opts = {})
      opts = opts.merge(offer_id: offer_id)
      opts = opts.merge(payout.options(opts))
      opts = opts.merge(received.options(opts))
      opts = opts.merge(expiration_date.options(opts))
      opts = NO_CHANGE_VALUES.merge(opts)
      require_params(opts, ALL_PARAMS)
      addedit_offer(opts)
      nil
    end

    def patch(offer_id, opts = {})
      offer = get(offer_id: offer_id).first
      default_contract = [offer.fetch(:offer_contracts).fetch(:offer_contract_info)].flatten
        .find { |c| c.fetch(:offer_contract_id) == offer.fetch(:default_offer_contract_id) }

      opts = NO_CHANGE_VALUES
        .merge(
          advertiser_id: offer.dig(:advertiser, :advertiser_id),
          allowed_media_type_ids: [offer.fetch(:allowed_media_types).fetch(:media_type)].flatten.map { |mt| mt.fetch(:media_type_id) },
          allowed_media_type_modification_type: 'do_not_change',
          auto_disposition_delay_hours: 0,
          # cookie_domain: 'trk_ad2games.cakemarketing.net', #offer.fetch(:cookie_domain_override),
          currency_id: offer.fetch(:currency).fetch(:currency_id),
          offer_contract_hidden: offer.fetch(:hidden),
          offer_type_id: offer.fetch(:offer_type).fetch(:offer_type_id),
          postback_url_ms_delay: offer.fetch(:pixel_info).fetch(:postback_delay_ms) || 0,
          price_format_id: default_contract.fetch(:price_format).fetch(:price_format_id),
          received_percentage: default_contract.fetch(:received).fetch(:is_percentage),
          redirect_domain: ENV.fetch('REDIRECT_DOMAIN'),
          tags: [offer.fetch(:tags).fetch(:tag)].flatten.map { |t| t.fetch(:tag_name) }.join(','),
          tags_modification_type: 'do_not_change',
          payout: 0,
          payout_modification_type: ModificationType::DO_NOT_CHANGE,
          received: 0,
          received_modification_type: ModificationType::DO_NOT_CHANGE
        )
        .merge(opts)
      update(offer_id, opts)
    end

    private

    def payout
      ModificationType.new(:payout, :payout_modification_type, 0)
    end

    def received
      ModificationType.new(:received, :received_modification_type, 0)
    end

    def expiration_date
      ModificationType.new(
        :expiration_date,
        :expiration_date_modification_type,
        Time.utc(1970, 1, 1)
      )
    end

    def addedit_offer(opts)
      opts = translate_booleans(opts)
      opts = translate_values(opts)
      client.run Request.new(:admin, :addedit, :offer, opts)
    end

    def client
      @client ||= Client.new
    end

    # TODO:
    # * offer_type_id, currency_id: not used on edit
    # * expiration_date expiration_date_modification_type
    # * allowed_media_type_ids allowed_media_type_modification_type
    # * payout payout_modification_type
    # * received received_modification_type
    # * tags tags_modification_type
  end
end
