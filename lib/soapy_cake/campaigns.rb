# frozen_string_literal: true
module SoapyCake
  class Campaigns
    include Helper

    # TODO: Figure out what `static_suppression` is for and whether it needs to
    # be in the list.
    ALL_PARAMS = %i(
      account_status_id affiliate_id auto_disposition_delay_hours campaign_id
      clear_session_on_conversion currency_id display_link_type_id
      expiration_date expiration_date_modification_type media_type_id
      offer_contract_id offer_id paid paid_redirects paid_upsells payout
      payout_update_option pixel_html postback_delay_ms postback_url
      redirect_404 redirect_domain redirect_offer_contract_id review test_link
      third_party_name unique_key_hash use_offer_contract_payout
    ).freeze

    DEFAULTS_FOR_CREATION = {
      campaign_id: 0, # Create a new campaign
      offer_contract_id: 0, # Use the default offer contract
      auto_disposition_delay_hours: 0, # Skip
      payout_update_option: 'change', # Needed?
      postback_delay_ms: -1, # Skip
      third_party_name: ''
    }.freeze

    NO_CHANGE_VALUES = {
      account_status_id: 0,
      expiration_date_modification_type: 'do_not_change',
      currency_id: 0,
      use_offer_contract_payout: 'no_change',
      payout_update_option: 'do_not_change',
      paid: 'no_change',
      paid_redirects: 'no_change',
      paid_upsells: 'no_change',
      review: 'no_change',
      auto_disposition_delay_hours: 0,
      redirect_offer_contract_id: 0,
      redirect_404: 'no_change',
      clear_session_on_conversion: 'no_change',
      postback_delay_ms: -1
    }.freeze

    def get(opts = {})
      client.run Request.new(:admin, :export, :campaigns, opts)
    end

    def create(opts = {})
      if opts.key?(:campaign_id) && opts.fetch(:campaign_id).nonzero?
        raise 'Cannot create a campaign while specifying a campaign_id'
      end
      opts = DEFAULTS_FOR_CREATION.merge(opts)
      response = addedit_campaign(opts)
      response.fetch(:success_info).fetch(:campaign_id)
    end

    def update(campaign_id, opts = {})
      opts = opts.merge(campaign_id: campaign_id)
      opts = opts.merge(payout.options(opts))
      opts = opts.merge(expiration_date.options(opts))
      opts = NO_CHANGE_VALUES.merge(opts)
      require_params(opts, ALL_PARAMS)
      addedit_campaign(opts)
      nil
    end

    def patch(campaign_id, opts = {})
      campaign = get(campaign_id: campaign_id).first
      opts = NO_CHANGE_VALUES
        .merge(
          affiliate_id: campaign.fetch(:affiliate).fetch(:affiliate_id),
          # Only present in production:
          display_link_type_id: campaign.dig(:link_display_type, :link_display_type_id) || 1,
          media_type_id: campaign.fetch(:media_type).fetch(:media_type_id),
          offer_contract_id: campaign.fetch(:offer_contract).fetch(:offer_contract_id),
          offer_id: campaign.fetch(:offer).fetch(:offer_id),
          payout: campaign.fetch(:payout).fetch(:amount),
          payout_update_option: 'do_not_change',
          pixel_html: campaign.fetch(:pixel_info).fetch(:pixel_html),
          postback_url: campaign.fetch(:pixel_info).fetch(:postback_url),
          redirect_domain: campaign.fetch(:redirect_domain),
          test_link: campaign.fetch(:test_link),
          unique_key_hash: campaign.fetch(:pixel_info).fetch(:hash_type).fetch(:hash_type_id),
          third_party_name: campaign.fetch(:third_party_name, '')
        )
        .merge(opts)
      update(campaign_id, opts)
      nil
    end

    private

    def payout
      ModificationType.new(:payout, :payout_update_option, 0)
    end

    def expiration_date
      ModificationType.new(
        :expiration_date,
        :expiration_date_modification_type,
        Date.new(1970, 1, 1)
      )
    end

    def addedit_campaign(opts)
      opts = translate_booleans(opts)
      client.run Request.new(:admin, :addedit, :campaign, opts)
    end

    def client
      @client ||= Client.new
    end
  end
end
