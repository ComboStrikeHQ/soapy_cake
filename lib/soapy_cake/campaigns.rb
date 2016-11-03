# frozen_string_literal: true
module SoapyCake
  class Campaigns
    include Helper

    REQUIRED = [
      :account_status_id,
      :affiliate_id,
      :auto_disposition_delay_hours,
      :campaign_id,
      :clear_session_on_conversion,
      :currency_id,
      :display_link_type_id,
      :expiration_date,
      :expiration_date_modification_type,
      :media_type_id,
      :offer_contract_id,
      :offer_id,
      :paid,
      :paid_redirects,
      :paid_upsells,
      :payout,
      :payout_update_option,
      :pixel_html,
      :postback_delay_ms,
      :postback_url,
      :redirect_404,
      :redirect_domain,
      :redirect_offer_contract_id,
      :review,
      # :static_suppression, # "Required, only used if global setting is enabled"
      :test_link,
      # :third_party_name, # ?
      :unique_key_hash,
      :use_offer_contract_payout
    ].freeze

    DEFAULTS_FOR_CREATION = {
      campaign_id: 0, # Create a new campaign
      offer_contract_id: 0, # Use the default offer contract
      auto_disposition_delay_hours: 0, # Skip
      payout_update_option: 'change', # Needed?
      postback_delay_ms: -1, # Skip
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
      opts = NO_CHANGE_VALUES.merge(opts)
      addedit_campaign(opts)
      nil
    end

    private

    def expiration_date_params(opts)
      case opts[:expiration_date_modification_type]
      when 'do_not_change', 'remove'
        opts.merge(expiration_date: Date.new(1970, 1, 1))
      when 'change'
        opts
      when nil
        opts.merge(
          expiration_date_modification_type: 'do_not_change',
          expiration_date: Date.new(1970, 1, 1)
        )
      end
    end

    def payout_params(opts)
      case opts[:payout_update_option]
      when 'do_not_change', 'remove'
        opts.merge(payout: 0)
      when 'change'
        opts
      when nil
        opts.merge(
          payout_update_option: 'do_not_change',
          payout: 0
        )
      end
    end

    def addedit_campaign(opts)
      opts = expiration_date_params(opts)
      require_params(opts, REQUIRED)
      opts = translate_booleans(opts)
      client.run Request.new(:admin, :addedit, :campaign, opts)
    end

    def client
      @client ||= Client.new
    end
  end
end
