module SoapyCake
  class Admin < Client
    def affiliate_bills(opts = {})
      run Request.new(:admin, :accounting, :export_affiliate_bills, opts)
    end

    def advertiser_bills(opts = {})
      run Request.new(:admin, :accounting, :export_advertiser_bills, opts)
    end

    def mark_affiliate_bill_as_received(opts = {})
      run Request.new(:admin, :accounting, :mark_affiliate_bill_as_received, opts)
    end

    def mark_affiliate_bill_as_paid(opts = {})
      run Request.new(:admin, :accounting, :mark_affiliate_bill_as_paid, opts)
    end

    def advertisers(opts = {})
      run Request.new(:admin, :export, :advertisers, opts)
    end

    def affiliates(opts = {})
      run Request.new(:admin, :export, :affiliates, opts)
    end

    def campaigns(opts = {})
      run Request.new(:admin, :export, :campaigns, opts)
    end

    def offers(opts = {})
      run Request.new(:admin, :export, :offers, opts)
    end

    def creatives(opts = {})
      run Request.new(:admin, :export, :creatives, opts)
    end

    def campaign_summary(opts = {})
      run Request.new(:admin, :reports, :campaign_summary, opts)
    end

    def offer_summary(opts = {})
      run Request.new(:admin, :reports, :offer_summary, opts)
    end

    def affiliate_summary(opts = {})
      run Request.new(:admin, :reports, :affiliate_summary, opts)
    end

    def advertiser_summary(opts = {})
      run Request.new(:admin, :reports, :advertiser_summary, opts)
    end

    def clicks(opts = {})
      run Request.new(:admin, :reports, :clicks, opts)
    end

    def conversions(opts = {})
      run Request.new(:admin, :reports, :conversions, opts.merge(conversion_type: 'conversions'))
    end

    def events(opts = {})
      run Request.new(:admin, :reports, :conversions, opts.merge(conversion_type: 'events'))
    end

    def traffic(opts = {})
      run Request.new(:admin, :reports, :traffic_export, opts)
    end

    def caps(opts = {})
      run Request.new(:admin, :reports, :caps, opts)
    end

    def currencies(*)
      run Request.new(:admin, :get, :currencies, {})
    end

    def tiers(*)
      run Request.new(:admin, :get, :affiliate_tiers, {})
    end

    def update_creative(opts = {})
      run Request.new(:admin, :addedit, :creative, opts)
    end

    def update_campaign(opts = {})
      run Request.new(:admin, :addedit, :campaign, opts)
    end

    def affiliate_signup(opts = {})
      run Request.new(:admin, :signup, :affiliate, opts)
    end

    def verticals(*)
      run Request.new(:admin, :get, :verticals, {})
    end

    def countries(*)
      run Request.new(:admin, :get, :countries, {})
    end
  end
end
