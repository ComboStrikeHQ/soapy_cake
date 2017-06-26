# frozen_string_literal: true

RSpec.describe SoapyCake::AdminBatched do
  subject(:admin_batched) { described_class.new }

  let(:admin) { instance_double(SoapyCake::Admin, xml_response?: false) }

  before do
    allow(SoapyCake::Admin).to receive(:new).and_return(admin)

    stub_const('SoapyCake::AdminBatched::BatchedRequest::LIMIT', 2)
  end

  it 'returns an enumerator and uses batched CAKE calls' do
    expect(admin).to receive(:offers)
      .with(advertiser: 1, start_at_row: 1, row_limit: 2).and_return(%i[a b].to_enum)
    expect(admin).to receive(:offers)
      .with(advertiser: 1, start_at_row: 3, row_limit: 2).and_return(%i[c].to_enum)

    result = admin_batched.offers(advertiser: 1)

    expect(result).to be_a(Enumerator)
    expect(result.to_a).to eq(%i[a b c])
  end

  it 'can use a custom limit' do
    expect(admin).to receive(:offers)
      .with(advertiser: 1, start_at_row: 1, row_limit: 100).and_return(%i[a b].to_enum)

    expect(admin_batched.offers({ advertiser: 1 }, 100).to_a).to eq(%i[a b])
  end

  context 'SoapyCake Batched with XMLResponse set' do
    subject(:admin_batched) { described_class.new(xml_response: true) }

    before do
      allow(admin).to receive(:xml_response?).and_return(true)
    end

    it 'returns all affiliates in batched mode' do
      expect(admin).to receive(:affiliates)
        .with(start_at_row: 1, row_limit: 10).and_return(%i[a].to_enum)
      expect(admin).to receive(:affiliates)
        .with(start_at_row: 11, row_limit: 10).and_return(%i[b].to_enum)
      expect(admin).to receive(:affiliates)
        .with(start_at_row: 21, row_limit: 10).and_return([].to_enum)

      result = admin_batched.affiliates({}, 10)

      expect(result).to be_a(Enumerator)
      expect(result.to_a).to eq(%i[a b])
    end
  end

  context 'errors' do
    it 'fails with an invalid method' do
      expect { admin_batched.something }.to raise_error(NoMethodError)
    end

    it 'fails when row_limit is set' do
      expect { admin_batched.offers(row_limit: 123) }.to(
        raise_error(/Cannot set .* in batched mode/)
      )
    end

    it 'fails when start_at_row is set' do
      expect { admin_batched.offers(start_at_row: 123) }.to(
        raise_error(/Cannot set .* in batched mode/)
      )
    end
  end
end
