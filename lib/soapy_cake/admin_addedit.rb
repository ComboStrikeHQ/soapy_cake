module SoapyCake
  class AdminAddedit < Client
    include Helper

    def add_offer(opts = {})
      require_params(opts, %i(
        hidden offer_status_id offer_type_id currency_id ssl click_cookie_days
        impression_cookie_days redirect_404 enable_view_thru_conversion
        click_trumps_impression disable_click_deduplication last_touch
        enable_transaction_id_deduplication postbacks_only fire_global_pixel
        fire_pixel_on_nonpaid_conversions offer_link thankyou_link from_lines
        subject_lines))

      addedit_offer(opts.merge(offer_id: 0))
    end

    def edit_offer(opts = {})
      validate_id(opts, :offer_id)

      addedit_offer(opts)
    end

    def add_geo_targets(opts = {})
      require_params(opts, %i(offer_contract_id countries set_targeting_to_geo))

      opts[:countries] = Array(opts[:countries]).join(',')

      run Request.new(:admin, :addedit, :geo_targets, opts.merge(add_edit_option: 'add'))
    end

    def add_offer_contract(opts = {})
      addedit_offer_contract(opts.merge(offer_contract_id: 0))
    end

    def edit_offer_contract(opts = {})
      validate_id(opts, :offer_contract_id)

      addedit_offer_contract(opts)
    end

    def update_caps(opts = {})
      require_params(opts, %i(cap_type_id cap_interval_id cap_amount send_alert_only))

      translate_values!(opts, %i(cap_type_id cap_interval_id))

      opts[:cap_amount] = -1 if opts[:cap_interval_id] == const_lookup(:cap_interval_id, :disabled)

      run Request.new(:admin, :addedit, :caps, opts)
    end

    def add_offer_tier(opts = {})
      require_params(opts, %i(offer_id tier_id price_format_id offer_contract_id status_id))

      opts.merge!(
        redirect_offer_contract_id: -1,
        add_edit_option: 'add'
      )

      opts[:status_id] = const_lookup(:offer_status_id, opts[:status_id]) if opts.key?(:status_id)
      translate_values!(opts, %i(price_format_id))

      run Request.new(:admin, :addedit, :offer_tiers, opts)
    end

    private

    def translate_values!(opts, params)
      params.each do |type|
        opts[type] = const_lookup(type, opts[type]) if opts.key?(type)
      end
    end

    def const_lookup(type, key)
      Const::CONSTS[type].fetch(key) do
        fail ArgumentError, "#{key} is not a valid value for #{type}"
      end
    end

    def addedit_offer(opts)
      require_params(opts, %i(
        advertiser_id vertical_id postback_url_ms_delay offer_contract_hidden
        price_format_id received received_percentage payout tags))

      opts.each do |k, v|
        opts[k] = 'on' if v == true
        opts[k] = 'off' if v == false
      end

      translate_values!(opts, %i(currency_id offer_status_id offer_type_id price_format_id))

      opts.reverse_merge!(
        offer_name: '',
        third_party_name: '',
        hidden: 'no_change',
        offer_status_id: 0,
        ssl: 'no_change',
        click_cookie_days: -1,
        impression_cookie_days: -1,
        redirect_offer_contract_id: 0,
        redirect_404: 'no_change',
        enable_view_thru_conversion: 'no_change',
        click_trumps_impression: 'no_change',
        disable_click_deduplication: 'no_change',
        last_touch: 'no_change',
        enable_transaction_id_deduplication: 'no_change',
        postbacks_only: 'no_change',
        pixel_html: '',
        postback_url: '',
        fire_global_pixel: 'no_change',
        fire_pixel_on_nonpaid_conversions: 'no_change',
        conversion_cap_behavior: const_lookup(:conversion_behaviour_id, :system),
        conversion_behavior_on_redirect: const_lookup(:conversion_behaviour_id, :system),
        expiration_date: Date.today + (365 * 100),
        expiration_date_modification_type: 'do_not_change',
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
        subject_lines: ''
      )

      run(Request.new(:admin, :addedit, :offer, opts))[:success_info]
    end

    def addedit_offer_contract(opts)
      require_params(opts, %i(
        offer_id offer_contract_id offer_contract_name price_format_id payout received
        received_percentage offer_link thankyou_link offer_contract_hidden
        offer_contract_is_default use_fallback_targeting))

      translate_values!(opts, %i(price_format_id))

      run Request.new(:admin, :addedit, :offer_contract, opts)
    end
  end
end
