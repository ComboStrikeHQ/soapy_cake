RSpec.describe SoapyCake::Admin do
  let(:opts) { nil }
  let(:cake_opts) { opts }
  let(:cake_method) { method }

  describe 'accounting service' do
    let(:service) { :accounting }

    describe '#affiliate_bills' do
      let(:method) { :affiliate_bills }
      let(:cake_method) { :export_affiliate_bills }
      it_behaves_like 'a cake admin method'
    end

    describe '#advertiser_bills' do
      let(:method) { :advertiser_bills }
      let(:cake_method) { :export_advertiser_bills }
      it_behaves_like 'a cake admin method'
    end

    describe '#mark_affiliate_bill_as_received' do
      let(:method) { :mark_affiliate_bill_as_received }
      it_behaves_like 'a cake admin method'
    end

    describe '#mark_affiliate_bill_as_paid' do
      let(:method) { :mark_affiliate_bill_as_paid }
      it_behaves_like 'a cake admin method'
    end
  end

  describe 'export service' do
    let(:service) { :export }

    describe '#advertisers' do
      let(:method) { :advertisers }
      it_behaves_like 'a cake admin method'
    end

    describe '#affiliates' do
      let(:method) { :affiliates }
      it_behaves_like 'a cake admin method'
    end

    describe '#campaigns' do
      let(:method) { :campaigns }
      it_behaves_like 'a cake admin method'
    end

    describe '#offers' do
      let(:method) { :offers }
      it_behaves_like 'a cake admin method'
    end

    describe '#creatives' do
      let(:method) { :creatives }
      it_behaves_like 'a cake admin method'
    end
  end

  describe 'reports service' do
    let(:service) { :reports }

    describe '#campaign_summary' do
      let(:method) { :campaign_summary }
      it_behaves_like 'a cake admin method'
    end

    describe '#offer_summary' do
      let(:method) { :offer_summary }
      it_behaves_like 'a cake admin method'
    end

    describe '#affiliate_summary' do
      let(:method) { :affiliate_summary }
      it_behaves_like 'a cake admin method'
    end

    describe '#advertiser_summary' do
      let(:method) { :advertiser_summary }
      it_behaves_like 'a cake admin method'
    end

    describe '#clicks' do
      let(:method) { :clicks }
      it_behaves_like 'a cake admin method'
    end

    describe '#conversions' do
      let(:method) { :conversions }
      let(:cake_opts) {  { conversion_type: 'conversions' } }
      it_behaves_like 'a cake admin method'
    end

    describe '#conversion_changes' do
      let(:method) { :conversion_changes }
      it_behaves_like 'a cake admin method'
    end

    describe '#events' do
      let(:method) { :events }
      let(:cake_method) { :conversions }
      let(:cake_opts) { { conversion_type: 'events' } }
      it_behaves_like 'a cake admin method'
    end

    describe '#traffic' do
      let(:method) { :traffic }
      let(:cake_method) { :traffic_export }
      it_behaves_like 'a cake admin method'
    end

    describe '#caps' do
      let(:method) { :caps }
      let(:cake_opts) { { start_date: '2015-07-01', end_date: '2015-07-07' } }
      it_behaves_like 'a cake admin method'
    end
  end

  describe 'get service' do
    let(:service) { :get }

    describe '#verticals' do
      let(:method) { :verticals }
      let(:cake_opts) { nil }
      it_behaves_like 'a cake admin method'
    end

    describe '#countries' do
      let(:method) { :countries }
      it_behaves_like 'a cake admin method'
    end

    describe '#currencies' do
      let(:method) { :currencies }
      let(:cake_opts) { nil }
      it_behaves_like 'a cake admin method'
    end

    describe '#exchange_rates' do
      let(:method) { :exchange_rates }
      let(:cake_opts) { { start_date: '2015-07-01', end_date: '2015-07-07' } }
      it_behaves_like 'a cake admin method'
    end

    describe '#tiers' do
      let(:method) { :tiers }
      let(:cake_method) { :affiliate_tiers }
      let(:cake_opts) { nil }
      it_behaves_like 'a cake admin method'
    end

    describe '#blacklist_reasons' do
      let(:method) { :blacklist_reasons }
      let(:cake_opts) { nil }
      it_behaves_like 'a cake admin method'
    end
  end

  describe 'addedit service' do
    let(:service) { :addedit }

    describe '#update_creative' do
      let(:method) { :update_creative }
      let(:cake_method) { :creative }
      it_behaves_like 'a cake admin method'
    end

    describe '#update_campaign' do
      let(:method) { :update_campaign }
      let(:cake_method) { :campaign }
      it_behaves_like 'a cake admin method'
    end

    describe '#add_blacklist' do
      around { |example| Timecop.freeze(Time.utc(2015, 2, 17), &example) }

      let(:method) { :add_blacklist }
      let(:cake_method) { :blacklist }
      let(:request) { double('request') }
      let(:opts) { { blacklist_date: date } }

      context 'immediate blacklisting for current date' do
        let(:date) { Date.today }
        let(:cake_opts) { { blacklist_date: date.to_s } }

        it_behaves_like 'a cake admin method'
      end

      context 'scheduled blacklisting in the future' do
        let(:date) { Date.new(2015, 9, 3) }
        let(:cake_opts) { { blacklist_date: (date + 1.day).to_s } }

        it_behaves_like 'a cake admin method'
      end
    end
  end

  describe 'signup service' do
    let(:service) { :signup }

    describe '#affiliate_signup' do
      let(:method) { :affiliate_signup }
      let(:cake_method) { :affiliate }
      it_behaves_like 'a cake admin method'
    end

    describe '#media_types' do
      let(:method) { :media_types }
      let(:cake_method) { :get_media_types }
      it_behaves_like 'a cake admin method'

      it 'uses a local response' do
        expect(subject.media_types(response: File.read('spec/fixtures/raw_response.xml'))).to eq(
          [
            { media_type_id: 15, type_name: 'Adware' },
            { media_type_id: 7, type_name: 'Banner' },
            { media_type_id: 17, type_name: 'Content' },
            { media_type_id: 6, type_name: 'Co-Reg' },
            { media_type_id: 3, type_name: 'Email' },
            { media_type_id: 12, type_name: 'Incentivized' },
            { media_type_id: 2, type_name: 'Network' },
            { media_type_id: 13, type_name: 'Other' },
            { media_type_id: 8, type_name: 'PopUnder' },
            { media_type_id: 4, type_name: 'PPC' },
            { media_type_id: 9, type_name: 'Radio' },
            { media_type_id: 5, type_name: 'SEO' },
            { media_type_id: 16, type_name: 'Social Media' },
            { media_type_id: 10, type_name: 'TV' },
            { media_type_id: 11, type_name: 'Upsell' },
            { media_type_id: 1, type_name: 'YouTube_Twitch' }
          ]
        )
      end
    end
  end
end
