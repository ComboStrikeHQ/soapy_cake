RSpec.describe 'ADDEDIT integration test' do
  subject { SoapyCake::AdminAddedit.new }

  let(:advertiser_id) { 15886 }
  let(:vertical_id) { 41 }
  let(:offer_id) { 8906 }

  it 'creates an offer', :vcr do
    result = subject.add_offer(
      hidden: false,
      offer_status_id: SoapyCake::Const::OFFER_STATUS_PUBLIC,
      offer_type_id: SoapyCake::Const::OFFER_TYPE_HOSTED,
      currency_id: SoapyCake::Const::CURRENCY_EUR,
      ssl: false,
      click_cookie_days: 30,
      impression_cookie_days: 30,
      redirect_404: 'off',
      enable_view_thru_conversion: 'off',
      click_trumps_impression: 'off',
      disable_click_deduplication: 'off',
      last_touch: 'off',
      enable_transaction_id_deduplication: 'off',
      postbacks_only: 'off',
      fire_global_pixel: 'on',
      fire_pixel_on_nonpaid_conversions: 'off',
      offer_link: 'http://www.example.com/',
      thankyou_link: 'http://www.example.com/',
      from_lines: 'from',
      subject_lines: 'subject',

      advertiser_id: advertiser_id,
      vertical_id: vertical_id,
      postback_url_ms_delay: 60,
      offer_contract_hidden: false,
      price_format_id: SoapyCake::Const::PRICE_FORMAT_CPA,
      received: 2.0,
      received_percentage: false,
      payout: 1.5,

      tags: '',
      offer_name: 'Test Offer',
      offer_description: 'TEST1',
      restrictions: 'TEST2',
      advertiser_extended_terms: 'TEST3',
      testing_instructions: 'TEST4',
    )

    expect(result).to include(
      creative_id: 9429,
      offer_contract_id: 1453,
      offer_id: 8908
    )
  end

  it 'updates an offer', :vcr do
    result = subject.edit_offer(
      offer_id: offer_id,

      advertiser_id: advertiser_id,
      vertical_id: vertical_id,
      postback_url_ms_delay: 50,
      offer_contract_hidden: false,
      price_format_id: SoapyCake::Const::PRICE_FORMAT_CPA,
      received: 2.0,
      received_percentage: false,
      payout: 1.5,
      tags: '',
    )

    expect(result).to include(offer_id: offer_id)
  end

  context 'errors' do
    it 'fails when not enough params are given' do
      expect do
        subject.edit_offer(offer_id: 123)
      end.to raise_error(RuntimeError, "Parameter 'advertiser_id' missing!")
    end

    it 'fails when invalid offer_id is given on edit' do
      expect do
        subject.edit_offer(offer_id: -1)
      end.to raise_error(RuntimeError, 'offer_id must be > 0')
    end
  end
end
