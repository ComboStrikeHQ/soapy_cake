require 'spec_helper'

RSpec.describe SoapyCake::Affiliate do
  subject { described_class.new(api_key: 'abc', affiliate_id: 1) }

  let(:client) { double('soap client') }

  describe '#bills' do
    it 'returns bills' do
      expect(SoapyCake::Client::CakeClient).to receive(:reports)
        .with(role: :affiliates)
        .and_return(client)

      expect(client).to receive(:bills).with(affiliate_id: 1, api_key: 'abc')

      subject.bills
    end
  end

  describe '#offer_feed' do
    let(:offers) { double('offers') }

    it 'returns offers' do
      expect(SoapyCake::Client::CakeClient).to receive(:offers)
        .with(role: :affiliates)
        .and_return(client)

      expect(client).to receive(:offer_feed)
        .with(affiliate_id: 1, api_key: 'abc', status_id: 3)
        .and_return(offers)

      expect(subject.offer_feed(status_id: 3)).to eq(offers)
    end
  end

  describe '#campaign' do
    let(:campaign) { double('campaign') }

    it 'returns a campaign' do
      expect(SoapyCake::Client::CakeClient).to receive(:offers)
        .with(role: :affiliates)
        .and_return(client)

      expect(client).to receive(:get_campaign)
        .with(affiliate_id: 1, api_key: 'abc', campaign_id: 12)
        .and_return(campaign)
      expect(subject.campaign(campaign_id: 12)).to eq(campaign)
    end
  end
end
