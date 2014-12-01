module SoapyCake
  class Advertiser
    attr_reader :api_key, :advertiser_id

    def initialize(opts = {})
      @api_key = opts[:api_key]
      @advertiser_id = opts[:advertiser_id]
    end

    def bills(opts = {})
      cake_client(:reports, :bills, opts)
    end

    private

    def cake_client(api, method, opts = {})
      Client::CakeClient.send(api, role: :advertisers)
        .public_send(method, opts.merge(advertiser_id: advertiser_id, api_key: api_key))
    end
  end
end
