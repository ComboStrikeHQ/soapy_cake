require 'spec_helper'

RSpec.describe SoapyCake::Admin do
  describe '.affiliate_bill_received!' do
    it 'marks an affiliate bill as received' do
      expect_any_instance_of(SoapyCake::Client::CakeClient)
        .to receive(:mark_affiliate_bill_as_received)
        .with(affiliate_id: 2)

      subject.affiliate_bill_received!(affiliate_id: 2)
    end
  end

  describe '.affiliate_bills' do
    it 'exports bills' do
      expect_any_instance_of(SoapyCake::Client::CakeClient)
        .to receive(:export_affiliate_bills)
        .with(affiliate_id: 2)

      subject.affiliate_bills(affiliate_id: 2)
    end
  end

  describe '.advertiser_bills' do
    it 'exports bills' do
      expect_any_instance_of(SoapyCake::Client::CakeClient)
        .to receive(:export_advertiser_bills)
        .with(advertiser_id: 2)

      subject.advertiser_bills(advertiser_id: 2)
    end
  end

  describe '.campaign_summary' do
    let(:start_date) { Date.new(2014, 7, 1) }
    let(:end_date) { Date.new(2014, 7, 3) }

    it 'returns the campaign summary report for the given days' do
      expect_any_instance_of(SoapyCake::Client::CakeClient)
        .to receive(:campaign_summary)
        .with(start_date: start_date, end_date: end_date, offer_id: 12)
        .and_return('result')

      expect(subject.campaign_summary(start_date: start_date, end_date: end_date, offer_id: 12))
        .to eq('result')
    end

    it 'returns the campaign summary report for the start_date if no end_date is given' do
      expect_any_instance_of(SoapyCake::Client::CakeClient)
        .to receive(:campaign_summary)
        .with(start_date: start_date, end_date: start_date + 1, offer_id: 12)
        .and_return('result')

      expect(subject.campaign_summary(start_date: start_date, offer_id: 12))
        .to eq('result')
    end
  end


  describe '.advertisers' do
    it 'returns advertisers' do
      expect_any_instance_of(SoapyCake::Client::CakeClient)
        .to receive(:advertisers)

      subject.advertisers
    end
  end

  describe '.affiliates' do
    it 'returns affiliates' do
      expect_any_instance_of(SoapyCake::Client::CakeClient)
        .to receive(:affiliates)

      subject.affiliates(force: true)
    end
  end

  describe '.campaigns' do
    it 'returns all campaigns' do
      opts = { foo: :bar }
      expected = [{ ping: :pong }]
      expect_any_instance_of(SoapyCake::Client::CakeClient)
        .to receive(:campaigns)
        .with(opts).and_return(expected)
      expect(subject.campaigns(opts)).to eq(expected)
    end
  end

  describe '.offers' do
    it 'returns all offers' do
      opts = { foo: :bar }
      expected = [{ ping: :pong }]
      expect_any_instance_of(SoapyCake::Client::CakeClient)
        .to receive(:offers)
        .with(opts).and_return(expected)
      expect(subject.offers(opts)).to eq(expected)
    end
  end

  describe '.affiliate_summary' do
    let(:start_date) { Date.new(2014, 7, 1) }
    let(:end_date) { Date.new(2014, 7, 3) }

    it 'returns the affiliate summary report for the given days' do
      expect_any_instance_of(SoapyCake::Client::CakeClient)
        .to receive(:affiliate_summary)
        .with(start_date: start_date, end_date: end_date).and_return(
          [{ affiliate: { affiliate_id: '1' } },
           { affiliate: { affiliate_id: '2' } }]
      )

      expect(subject.affiliate_summary(start_date: start_date, end_date: end_date))
        .to eq(
          [{ affiliate: { affiliate_id: '1' } },
           { affiliate: { affiliate_id: '2' } }]
        )
    end

    it 'returns the affiliate summary report for the start_date if no end_date is given' do
      expect_any_instance_of(SoapyCake::Client::CakeClient)
        .to receive(:affiliate_summary)
        .with(start_date: start_date, end_date: start_date + 1).and_return(
          [{ affiliate: { affiliate_id: '1' } },
           { affiliate: { affiliate_id: '2' } }]
        )

      expect(subject.affiliate_summary(start_date: start_date)).to eq(
        [{ affiliate: { affiliate_id: '1' } },
         { affiliate: { affiliate_id: '2' } }]
      )
    end
  end

  describe '.advertiser_summary' do
    let(:start_date) { Date.new(2014, 7, 1) }
    let(:end_date) { Date.new(2014, 7, 3) }

    it 'returns the advertiser summary report for the given days' do
      expect_any_instance_of(SoapyCake::Client::CakeClient)
        .to receive(:advertiser_summary)
        .with(start_date: start_date, end_date: end_date).and_return(
          [{ advertiser: { advertiser_id: '1' } },
           { advertiser: { advertiser_id: '2' } }]
        )

      expect(subject.advertiser_summary(start_date: start_date, end_date: end_date))
        .to eq(
          [{ advertiser: { advertiser_id: '1' } },
           { advertiser: { advertiser_id: '2' } }]
        )
    end

    it 'returns the advertiser summary report for the start_date if no end_date is given' do
      expect_any_instance_of(SoapyCake::Client::CakeClient)
        .to receive(:advertiser_summary)
        .with(start_date: start_date, end_date: start_date + 1).and_return(
          [{ advertiser: { advertiser_id: '1' } },
           { advertiser: { advertiser_id: '2' } }]
        )

      expect(subject.advertiser_summary(start_date: start_date)).to eq(
        [{ advertiser: { advertiser_id: '1' } },
         { advertiser: { advertiser_id: '2' } }]
      )
    end
  end

  describe '.offer_summary' do
    let(:start_date) { Date.new(2014, 7, 1) }
    let(:end_date) { Date.new(2014, 7, 3) }

    it 'returns the offer summary report for the given days' do
      expect_any_instance_of(SoapyCake::Client::CakeClient)
        .to receive(:offer_summary)
        .with(start_date: start_date, end_date: end_date, offer_id: 1)
        .and_return('result')

      expect(subject.offer_summary(start_date: start_date, end_date: end_date, offer_id: 1))
        .to eq('result')
    end

    it 'returns the offer summary report for the start_date if no end_date is given' do
      expect_any_instance_of(SoapyCake::Client::CakeClient)
        .to receive(:offer_summary)
        .with(start_date: start_date, end_date: start_date + 1, offer_id: 1)
        .and_return('result')

      expect(subject.offer_summary(start_date: start_date, offer_id: 1))
        .to eq('result')
    end
  end

  describe '.conversions' do
    it 'returns only conversions' do
      expect_any_instance_of(SoapyCake::Client::CakeClient)
        .to receive(:conversions)
        .with(color: 'green', conversion_type: 'conversions')

      subject.conversions(color: 'green')
    end
  end

  describe '.events' do
    it 'returns only events' do
      expect_any_instance_of(SoapyCake::Client::CakeClient)
        .to receive(:conversions)
        .with(color: 'red', conversion_type: 'events')

      subject.events(color: 'red')
    end
  end

  describe '#mark_affiliate_bill_as_paid' do
    it 'marks credit notes as paid' do
      expect_any_instance_of(SoapyCake::Client::CakeClient)
        .to receive(:mark_affiliate_bill_as_paid).with(bill_id: 1)
      subject.mark_affiliate_bill_as_paid(bill_id: 1)
    end
  end

  describe '#creatives' do
    it 'fetches creatives from CAKE' do
      expect_any_instance_of(SoapyCake::Client::CakeClient)
        .to receive(:creatives)
        .with(offer_id: 1)
      subject.creatives(offer_id: 1)
    end
  end

  describe '#traffic' do
    let(:start_date) { Date.new(2014, 7, 1) }
    let(:end_date) { Date.new(2014, 7, 3) }

    it 'fetches a traffic report' do
      expect_any_instance_of(SoapyCake::Client::CakeClient)
        .to receive(:traffic_export)
        .with(start_date: start_date, end_date: end_date)

      subject.traffic(start_date: start_date, end_date: end_date)
    end
  end

  describe '#update_creative' do
    it 'updates a creative' do
      expect_any_instance_of(SoapyCake::Client::CakeClient).to receive(:creative)
        .with(offer_id: 1, creative_status_id: 1)

      subject.update_creative(offer_id: 1, creative_status_id: 1)
    end
  end
end
