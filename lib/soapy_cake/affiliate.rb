module SoapyCake
  class Affiliate
    attr_reader :api_key, :affiliate_id

    def initialize(opts = {})
      @api_key = opts[:api_key]
      @affiliate_id = opts[:affiliate_id]
    end

    def bills(opts = {})
      cake_client(:reports, :bills, opts)
    end

    def offer_feed(opts = {})
      cake_client(:offers, :offer_feed, opts)
    end

    def campaign(opts = {})
      cake_client(:offers, :get_campaign, opts)
    end

    private

    def cake_client(api, method, opts = {})
      Client::CakeClient.send(api, role: :affiliates)
        .send(method, opts.merge(affiliate_id: affiliate_id, api_key: api_key))
    end
  end
end
