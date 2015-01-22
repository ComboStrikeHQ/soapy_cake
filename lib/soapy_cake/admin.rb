module SoapyCake
  class Admin
    def initialize(_opts = {})
    end

    def affiliate_bills(opts = {})
      Client::CakeClient.accounting.export_affiliate_bills(opts)
    end

    def advertiser_bills(opts = {})
      Client::CakeClient.accounting.export_advertiser_bills(opts)
    end

    def affiliate_bill_received!(opts = {})
      Client::CakeClient.accounting.mark_affiliate_bill_as_received(opts)
    end

    def advertisers(opts = {})
      Client::CakeClient.export.advertisers(opts)
    end

    def affiliates(opts = {})
      Client::CakeClient.export.affiliates(opts)
    end

    def campaigns(opts = {})
      Client::CakeClient.export.campaigns(opts)
    end

    def offers(opts = {})
      Client::CakeClient.export.offers(opts)
    end

    def campaign_summary(opts)
      Client::CakeClient.reports.campaign_summary(opts_with_date_range(opts))
    end

    def offer_summary(opts)
      Client::CakeClient.reports.offer_summary(opts_with_date_range(opts))
    end

    def affiliate_summary(opts)
      Client::CakeClient.reports.affiliate_summary(opts_with_date_range(opts))
    end

    def advertiser_summary(opts)
      Client::CakeClient.reports.advertiser_summary(opts_with_date_range(opts))
    end

    def clicks(opts)
      Client::CakeClient.reports.conversions(opts)
    end

    def conversions(opts)
      Client::CakeClient.reports.conversions(opts.merge(conversion_type: 'conversions'))
    end

    def events(opts)
      Client::CakeClient.reports.conversions(opts.merge(conversion_type: 'events'))
    end

    def currencies
      Client::CakeClient.get.currencies
    end

    def mark_affiliate_bill_as_paid(opts)
      Client::CakeClient.accounting.mark_affiliate_bill_as_paid(opts)
    end

    def creatives(opts = {})
      Client::CakeClient.export.creatives(opts)
    end

    def update_creative(opts = {})
      Client::CakeClient.addedit.creative(opts)
    end

    def traffic(opts)
      Client::CakeClient.reports.traffic_export(opts_with_date_range(opts))
    end

    private

    def opts_with_date_range(opts)
      start_date = opts[:start_date].to_date
      end_date = opts[:end_date] || start_date + 1

      opts.merge(start_date: start_date, end_date: end_date)
    end
  end
end
