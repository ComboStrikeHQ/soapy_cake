# frozen_string_literal: true

RSpec.describe SoapyCake::Admin do
  around { |example| Timecop.freeze(Time.utc(2015, 6, 15, 12), &example) }

  let(:logger) { instance_double(Logger) }

  before { allow(logger).to receive(:info) }

  subject(:admin) { described_class.new(logger: logger) }

  it 'returns an affiliate with correct data types', :vcr do
    expect(logger).to receive(:info)
      .with('soapy_cake:request admin:export:affiliates:5 {"affiliate_id":16027}')

    result = admin.affiliates(affiliate_id: 16027)
    expect(result.count).to eq(1)
    expect(result.first).to include(
      affiliate_id: 16027,
      # strings
      affiliate_name: 'Affiliate Test 1',
      # booleans
      hide_offers: false,
      # hashes and id-params
      billing_cycle: { billing_cycle_id: 1, billing_cycle_name: 'Weekly' },
      # floats
      minimum_payment_threshold: '0.0000'
    )

    # dates
    expect(result.first[:date_created]).to be_a(Time)
    expect(result.first[:date_created].to_s)
      .to eq(Time.utc(2014, 4, 28, 8, 52, 15.537).to_s)

    # strings should be actual Strings, not some Saxerator element class
    expect(result.first[:affiliate_name].class).to eq(String)

    # arrays
    expect(result.first[:contacts][:contact_info].map { |contact| contact[:contact_id] }).to \
      eq([8819, 8820])
  end

  it 'returns a clicks report with a defined time range', :vcr do
    result = admin.clicks(
      start_date: Date.new(2017, 5, 31),
      end_date: Date.new(2017, 6, 1),
      row_limit: 1
    )

    expect(result.count).to eq(1)
    expect(result.first).to include(
      click_id: 1633967829,
      visitor_id: 964629655
    )
  end

  it 'does not parse a transaction_id as an integer', :vcr do
    result = admin.conversions(
      start_date: Date.new(2015, 5, 8),
      end_date: Date.new(2015, 5, 9),
      row_limit: 1
    )

    expect(result.count).to eq(1)
    expect(result.first[:transaction_id]).to eq('TRANSACTION_ID')
  end

  it 'raises if there is an error', :vcr do
    expect { admin.affiliates(affiliate_id: 'bloops') }
      .to raise_error(SoapyCake::RequestFailed) do |e|
        expect(e.request_path).to eq('/api/5/export.asmx')
        expect(e.request_body).to include('<cake:affiliate_id>bloops</cake:affiliate_id>')
        expect(e.response_body).to include('There is an error in XML document')
      end
  end

  it 'creates an affiliate and returns the ID', :vcr do
    result = admin.affiliate_signup(
      contact_timezone: 'CET',
      contact_phone_work: 'n/a',
      address_country: 'n/a',
      ssn_tax_id: 'n/a',
      tax_class: 'n/a',
      address_street: 'n/a',
      address_city: 'n/a',
      address_state: 'n/a',
      address_zip_code: 'n/a',
      account_status_id: SoapyCake::Const::CONSTS[:account_status_id][:active],
      affiliate_name: 'Foxy Fox',
      contact_first_name: 'Foxy',
      contact_last_name: 'Fox',
      contact_email_address: 'foxy@forrest.com',
      date_added: Date.current
    )

    expect(result).to eq(
      success: true,
      message: 'Affiliate Added Successfully',
      affiliate_id: 16173,
      tipalti_iframe_expiration_date: nil
    )
  end

  it 'returns media types', :vcr do
    result = admin.media_types

    expect(result.first).to eq(
      media_type_id: 15,
      type_name: 'Adware'
    )
  end

  context 'XML responses' do
    subject(:admin) { described_class.new(xml_response: true) }

    it 'returns an XML string', :vcr do
      result = admin.media_types

      expect(result.next).to eq(File.read('spec/fixtures/raw_response.xml').strip)
    end

    it 'fails on error', :vcr do
      expect do
        admin.affiliates(affiliate_id: -2).next
      end.to raise_error(SoapyCake::RequestFailed)
    end
  end

  describe '#blacklists' do
    it 'returns blacklists', :vcr do
      expect(
        admin.blacklists(
          advertiser_id: 15882,
          offer_id: 10551,
          affiliate_id: 16187,
          sub_id: 'somesub'
        ).first
      ).to eq(
        advertiser: { advertiser_id: 15882, advertiser_name: ' NetDragon Websoft Inc. ' },
        affiliate: { affiliate_id: 16187, affiliate_name: 'Illuminati Corp.' },
        blacklist_id: 202,
        blacklist_reason: {
          blacklist_reason_id: 5,
          blacklist_reason_name: 'Fraud - suspicious user-data'
        },
        blacklist_type: { blacklist_type_id: 1, blacklist_type_name: 'Global Redirect' },
        date_created: Time.utc(2015, 9, 22, 22),
        offer: { offer_id: 10551, offer_name: 'DO NOT USE: Foxy Test 42 (AD DOI)' },
        sub_id: 'somesub'
      )
    end
  end

  describe '#remove_blacklist' do
    let(:blacklist_params) do
      {
        advertiser_id: 14407,
        offer_id: 9738,
        affiliate_id: 15623,
        sub_id: '119960714'
      }
    end

    it 'removes blacklists', :vcr do
      expect(admin.blacklists(blacklist_params).to_a).to be_present

      admin.remove_blacklist(blacklist_id: 28)

      expect(admin.blacklists(blacklist_params).to_a).to be_empty
    end
  end
end
