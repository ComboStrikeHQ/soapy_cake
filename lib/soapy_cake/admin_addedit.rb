module SoapyCake
  class AdminAddedit < Client
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
      require_params(opts, %i(offer_id))
      fail 'offer_id must be > 0' if opts[:offer_id].to_i < 1

      addedit_offer(opts)
    end

    private

    def addedit_offer(opts)
      require_params(opts, %i(
        advertiser_id vertical_id postback_url_ms_delay offer_contract_hidden
        price_format_id received received_percentage payout tags))

      opts.each do |k, v|
        opts[k] = 'on' if v == true
        opts[k] = 'off' if v == false
      end

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
        conversion_cap_behavior: Const::CONVERSION_BEHAVIOR_SYSTEM,
        conversion_behavior_on_redirect: Const::CONVERSION_BEHAVIOR_SYSTEM,
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

      run Request.new(:admin, :addedit, :offer, opts)
    end

    def require_params(opts, params)
      params.each do |param|
        fail "Parameter '#{param}' missing!" unless opts.key?(param)
      end
    end
  end
end