# frozen_string_literal: true

module SoapyCake
  class Campaigns
    include Helper

    # TODO: Figure out what `static_suppression` is for and whether it needs to
    # be in the list.
    ALL_PARAMS = %i[
      account_status_id affiliate_id auto_disposition_delay_hours campaign_id
      clear_session_on_conversion currency_id expiration_date
      expiration_date_modification_type media_type_id offer_contract_id
      offer_id paid paid_redirects paid_upsells payout payout_update_option
      pixel_html postback_delay_ms postback_url redirect_404 redirect_domain
      redirect_offer_contract_id review test_link third_party_name
      unique_key_hash use_offer_contract_payout
    ].freeze

    NO_CHANGE_VALUES = {
      account_status_id: 0,
      expiration_date_modification_type: ModificationType::DO_NOT_CHANGE,
      currency_id: 0,
      use_offer_contract_payout: 'no_change',
      payout_update_option: ModificationType::DO_NOT_CHANGE,
      paid: 'no_change',
      paid_redirects: 'no_change',
      paid_upsells: 'no_change',
      review: 'no_change',
      auto_disposition_delay_hours: -1,
      redirect_offer_contract_id: 0,
      redirect_404: 'no_change',
      clear_session_on_conversion: 'no_change',
      postback_delay_ms: -1
    }.freeze

    delegate :read_only?, to: :client

    def get(opts = {})
      client.run Request.new(:admin, :export, :campaigns, opts)
    end

    def create(opts = {})
      response = addedit_campaign(opts.merge(campaign_id: 0))
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
          media_type_id: campaign.fetch(:media_type).fetch(:media_type_id),
          offer_contract_id: campaign.fetch(:offer_contract).fetch(:offer_contract_id),
          offer_id: campaign.fetch(:offer).fetch(:offer_id),
          payout: campaign.fetch(:payout).fetch(:amount),
          payout_update_option: 'do_not_change',
          pixel_html: campaign.dig(:pixel_info, :pixel_html) || '',
          postback_url: campaign.dig(:pixel_info, :postback_url) || '',
          redirect_domain: campaign.fetch(:redirect_domain, ''),
          test_link: campaign[:test_link] || '',
          unique_key_hash: campaign.dig(:pixel_info, :hash_type, :hash_type_id) || 'none',
          third_party_name: campaign.fetch(:third_party_name, '')
        )
        .merge(display_link_type_opts(campaign))
        .merge(opts)
      update(campaign_id, opts)
      nil
    end

    private

    def display_link_type_opts(campaign)
      display_link_type_id = campaign.dig(:display_link_type, :link_display_type_id)
      display_link_type_id.nil? ? {} : { display_link_type_id: display_link_type_id }
    end

    def payout
      ModificationType.new(:payout, :payout_update_option, 0)
    end

    def expiration_date
      ModificationType.new(
        :expiration_date,
        :expiration_date_modification_type,
        Time.utc(1970, 1, 1)
      )
    end

    def addedit_campaign(opts)
      opts = translate_booleans(opts)
      opts = translate_values(opts)
      client.run Request.new(:admin, :addedit, :campaign, opts)
    end

    def client
      @client ||= Client.new
    end
  end
end
