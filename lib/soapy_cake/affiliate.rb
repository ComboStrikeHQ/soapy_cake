# frozen_string_literal: true

module SoapyCake
  class Affiliate < Client
    def bills(opts = {})
      run Request.new(:affiliate, :reports, :bills, affiliate_opts(opts))
    end

    def offer_feed(opts = {})
      run Request.new(:affiliate, :offers, :offer_feed, affiliate_opts(opts))
    end

    private

    def affiliate_opts(opts)
      { affiliate_id: self.opts[:affiliate_id] }.merge(opts)
    end
  end
end
