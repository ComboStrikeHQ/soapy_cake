# frozen_string_literal: true

module SoapyCake
  module Const
    # The ID mapping in the API docs is wrong, these values are taken from the UI.
    CONVERSION_BEHAVIOUR_ID = {
      system: 0,
      adv_off: 1,
      adv_no_aff: 2,
      no_adv_aff: 3,
      no_adv_no_aff: 4,
      ignore: 5
    }.freeze

    OFFER_STATUS_ID = {
      public: 1,
      private: 2,
      apply_to_run: 3,
      inactive: 4
    }.freeze

    CONSTS = {
      account_status_id: {
        no_change: 0,
        active: 1,
        inactive: 2,
        pending: 3
      },
      offer_status_id: OFFER_STATUS_ID,
      status_id: OFFER_STATUS_ID,
      offer_type_id: {
        hosted: 1,
        host_n_post: 2,
        third_party: 3
      },
      currency_id: {
        usd: 1,
        eur: 2,
        gbd: 3,
        aud: 4,
        cad: 5
      },
      payment_setting_id: {
        system_default: 1,
        offer_currency: 2,
        affiliate_currency: 3
      },
      price_format_id: {
        cpa: 1,
        cpc: 2,
        cpm: 3,
        fixed: 4,
        revshare: 5
      },
      conversion_behavior_id: CONVERSION_BEHAVIOUR_ID,
      conversion_cap_behavior: CONVERSION_BEHAVIOUR_ID,
      conversion_behavior_on_redirect: CONVERSION_BEHAVIOUR_ID,
      conversion_disposition_id: {
        pending: 1,
        rejected: 2,
        approved: 3,
        returned: 4
      },
      cap_type_id: {
        click: 1,
        conversion: 2
      },
      cap_interval_id: {
        indefinite: 0,
        daily: 1,
        weekly: 2,
        monthly: 3,
        custom: 4
      },
      creative_type_id: {
        # taken from https://support.getcake.com/support/solutions/articles/5000546087-addedit-creative-api-version-1
        link: 1,
        email: 2,
        image: 3,
        flash: 4,
        text: 5,
        html: 6,
        video: 7
      },
      creative_status_id: {
        active: 1,
        inactive: 2,
        hidden: 3
      }
    }.freeze
  end
end
