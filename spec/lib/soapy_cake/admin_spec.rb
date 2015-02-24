RSpec.describe SoapyCake::Admin do
  let(:opts) { { a: 1 } }
  let(:cake_opts) { opts }
  let(:cake_method) { method }

  shared_examples_for 'a cake admin method' do
    it 'runs the request' do
      request = double('request')
      expect(SoapyCake::Request).to receive(:new)
        .with(:admin, service, cake_method, cake_opts).and_return(request)
      expect(subject).to receive(:run).with(request)

      subject.public_send(method, opts)
    end
  end

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
      let(:cake_opts) { opts.merge(conversion_type: 'conversions') }
      it_behaves_like 'a cake admin method'
    end

    describe '#events' do
      let(:method) { :events }
      let(:cake_method) { :conversions }
      let(:cake_opts) { opts.merge(conversion_type: 'events') }
      it_behaves_like 'a cake admin method'
    end

    describe '#traffic' do
      let(:method) { :traffic }
      let(:cake_method) { :traffic_export }
      it_behaves_like 'a cake admin method'
    end

    describe '#caps' do
      let(:method) { :caps }
      it_behaves_like 'a cake admin method'
    end
  end

  describe 'get service' do
    let(:service) { :get }

    describe '#verticals' do
      let(:method) { :verticals }
      let(:cake_opts) { {} }
      it_behaves_like 'a cake admin method'
    end

    describe '#currencies' do
      let(:method) { :currencies }
      let(:cake_opts) { {} }
      it_behaves_like 'a cake admin method'
    end

    describe '#tiers' do
      let(:method) { :tiers }
      let(:cake_method) { :affiliate_tiers }
      let(:cake_opts) { {} }
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
  end

  describe 'signup service' do
    let(:service) { :signup }

    describe '#affiliate_signup' do
      let(:method) { :affiliate_signup }
      let(:cake_method) { :affiliate }
      it_behaves_like 'a cake admin method'
    end
  end
end
