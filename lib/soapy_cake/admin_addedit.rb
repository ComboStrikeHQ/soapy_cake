module SoapyCake
  class AdminAddedit < Client
    include Helper

    OFFER_DEFAULT_OPTIONS = {
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
      subject_lines: '',
      conversions_from_whitelist_only: 'off',
      allowed_media_type_modification_type: 'do_not_change',
      track_search_terms_from_non_supported_search_engines: 'off',
      auto_disposition_type: 'none',
      auto_disposition_delay_hours: '0',
      session_regeneration_seconds: -1,
      session_regeneration_type_id: 0,
      redirect_domain: '',
      cookie_domain: '',
      payout_modification_type: 'change',
      received_modification_type: 'change',
      tags_modification_type: 'do_not_change'
    }

    def add_offer(opts = {})
      require_params(opts, %i(
        hidden offer_status_id offer_type_id currency_id ssl click_cookie_days
        impression_cookie_days redirect_404 enable_view_thru_conversions
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
      require_params(opts, %i(offer_contract_id allow_countries))

      if opts[:allow_countries]
        require_params(opts, %i(countries))
        countries = Array(opts[:countries])
        opts[:countries] = countries.join(',')
        opts[:redirect_offer_contract_ids] = ([0] * countries.count).join(',')
      else
        unless opts[:redirects].is_a?(Hash) && opts[:redirects].keys.count > 0
          fail Error, "Parameter 'redirects' must be a COUNTRY=>REDIRECT_OFFER_CONTRACT_ID hash!"
        end

        opts[:countries] = opts[:redirects].keys.join(',')
        opts[:redirect_offer_contract_ids] = opts[:redirects].values.join(',')
        opts.delete(:redirects)
      end

      opts.merge!(
        add_edit_option: 'add',
        set_targeting_to_geo: true
      )

      run Request.new(:admin, :addedit, :geo_targets, opts)
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

      if opts[:tags]
        if opts[:tags].to_s == ''
          opts[:tags_modification_type] = 'remove_all'
          opts[:tags] = ''
        else
          opts[:tags_modification_type] = opts[:offer_id] ? 'add' : 'replace'
          opts[:tags] = Array(opts[:tags]).join(',')
        end
      end

      opts.each do |k, v|
        opts[k] = 'on' if v == true
        opts[k] = 'off' if v == false
      end

      translate_values!(opts, %i(currency_id offer_status_id offer_type_id price_format_id))

      %i(conversion_cap_behavior conversion_behavior_on_redirect).each do |key|
        next unless opts[key]
        opts[key] = const_lookup(:conversion_behaviour_id, opts[key])
      end

      opts.reverse_merge!(OFFER_DEFAULT_OPTIONS)
      opts.reverse_merge!(
        conversion_cap_behavior: const_lookup(:conversion_behaviour_id, :system),
        conversion_behavior_on_redirect: const_lookup(:conversion_behaviour_id, :system),
        expiration_date: Date.today + (365 * 100)
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
