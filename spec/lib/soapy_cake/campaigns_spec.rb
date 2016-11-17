# frozen_string_literal: true
RSpec.describe SoapyCake::Campaigns do
  let(:campaigns) { described_class.new }
  let(:client) { instance_double(SoapyCake::Client) }
  let(:campaign_id) { 1 }

  before do
    allow(SoapyCake::Client).to receive(:new).and_return(client)
    allow(client).to receive(:run).with(an_instance_of(SoapyCake::Request))
  end

  let(:default_params) do
    {
      affiliate_id: 1,
      display_link_type_id: 2,
      media_type_id: 3,
      offer_contract_id: 4,
      offer_id: 5,
      payout: 6.0,
      pixel_html: '<img src="https://example.com/pixel.png">',
      postback_url: 'http://example.com/postback',
      redirect_domain: 'example.com',
      test_link: 'http://example.com/test',
      third_party_name: 'Max',
      unique_key_hash: 'foo'
    }
  end

  def expect_request_to_be_built_with(opts)
    expect(SoapyCake::Request).to receive(:new).with(
      :admin,
      :addedit,
      :campaign,
      a_hash_including(opts)
    ).and_call_original
  end

  context 'setting an expiration date' do
    let(:expiration_date) { Time.new(2016, 11, 10) }

    context 'without an `expiration_date_modification_type`' do
      it 'changes the expiration date if an `expiration_date` is provided' do
        expect_request_to_be_built_with(
          expiration_date: expiration_date,
          expiration_date_modification_type: 'change'
        )

        campaigns.update(
          campaign_id,
          default_params.merge(expiration_date: expiration_date)
        )
      end

      it 'removes the expiration date if no `expiration_date` is provided' do
        expect_request_to_be_built_with(
          expiration_date: Time.utc(1970, 1, 1),
          expiration_date_modification_type: 'remove'
        )

        campaigns.update(campaign_id, default_params)
      end
    end

    context 'with an `expiration_date_modification_type` provided' do
      it 'passes along both, the `expiration_date` and `expiration_date_modification_type`' do
        expect_request_to_be_built_with(
          expiration_date: expiration_date,
          expiration_date_modification_type: 'change'
        )

        campaigns.update(
          campaign_id,
          default_params.merge(expiration_date: expiration_date,
                               expiration_date_modification_type: 'change')
        )
      end

      it 'sets the expiration_date to something if the modification type is `remove`' do
        expect_request_to_be_built_with(
          expiration_date: Time.utc(1970, 1, 1),
          expiration_date_modification_type: 'remove'
        )

        campaigns.update(
          campaign_id,
          default_params.merge(expiration_date_modification_type: 'remove')
        )
      end
    end
  end

  context 'setting a payout' do
    context '`payout_update_option` is not provided' do
      it 'changes the payout if a payout is provided' do
        expect_request_to_be_built_with(payout: 1.23, payout_update_option: 'change')

        campaigns.update(
          campaign_id,
          default_params.merge(payout: 1.23)
        )
      end
    end
  end

  describe 'translating values' do
    it 'translates values that have a translation' do
      expect_request_to_be_built_with(account_status_id: 3)

      campaigns.update(
        campaign_id,
        default_params.merge(account_status_id: :pending)
      )
    end

    it 'does not translate values that already have a numeric value' do
      expect_request_to_be_built_with(account_status_id: 3)

      campaigns.update(
        campaign_id,
        default_params.merge(account_status_id: 3)
      )
    end
  end
end
