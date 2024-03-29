# frozen_string_literal: true

module SoapyCake
  class AdminTrack < Client
    include Helper

    CONVERSION_DEFAULTS = {
      add_to_existing_payout: false,
      received_option: 'total_revenue',
      received: 0,
      disposition_type: 'no_change',
      update_revshare_payout: false,
      effective_date_option: 'today',
      notes_to_append: '',
      disallow_on_billing_status: 'ignore'
    }.freeze

    def mass_conversion_insert(opts)
      require_params(opts, %i[
                       conversion_date affiliate_id sub_affiliate
                       campaign_id creative_id total_to_insert
                     ])
      run Request.new(:admin, :track, :mass_conversion_insert, opts)
    end

    def update_conversion(opts)
      require_params(opts, %i[offer_id payout])

      run Request.new(:admin, :track, :update_conversion_events, CONVERSION_DEFAULTS.merge(opts))
    end

    def decrypt_affiliate_link(opts = {})
      run Request.new(:admin, :track, :decrypt_affiliate_link, opts)
    end
  end
end
