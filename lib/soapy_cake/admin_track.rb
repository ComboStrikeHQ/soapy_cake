module SoapyCake
  class AdminTrack < Client
    include Helper

    def mass_conversion_insert(opts)
      require_params(
        opts,
        %i(
          conversion_date affiliate_id sub_affiliate
          campaign_id creative_id total_to_insert
        )
      )

      run Request.new(:admin, :track, :mass_conversion_insert, opts)
    end

    def decrypt_affiliate_link(opts = {})
      run Request.new(:admin, :track, :decrypt_affiliate_link, opts)
    end
  end
end
