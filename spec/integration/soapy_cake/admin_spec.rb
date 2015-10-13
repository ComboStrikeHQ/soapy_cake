RSpec.describe SoapyCake::Admin do
  around { |example| Timecop.freeze(Time.utc(2015, 6, 15, 12), &example) }

  it 'returns an affiliate with correct data types', :vcr do
    result = subject.affiliates(affiliate_id: 16027)
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
    expect(result.first[:date_created]).to be_a(ActiveSupport::TimeWithZone)
    expect(result.first[:date_created].to_s)
      .to eq(Time.new(2014, 4, 28, 10, 52, 15.537, '+02:00').to_s)

    # strings should be actual Strings, not some Saxerator element class
    expect(result.first[:affiliate_name].class).to eq(String)

    # arrays
    expect(result.first[:contacts][:contact_info].map { |contact| contact[:contact_id] }).to \
      eq([8819, 8820])
  end

  it 'returns a clicks report with a defined time range', :vcr do
    result = subject.clicks(
      start_date: Date.new(2014, 6, 30),
      end_date: Date.new(2014, 7, 1),
      row_limit: 1
    )

    expect(result.count).to eq(1)
    expect(result.first).to include(
      click_id: 1275452,
      visitor_id: 1208222
    )
  end

  it 'does not parse a transaction_id as an integer', :vcr do
    result = subject.conversions(
      start_date: Date.new(2015, 4, 11),
      end_date: Date.new(2015, 4, 12),
      row_limit: 1
    )

    expect(result.count).to eq(1)
    expect(result.first[:transaction_id]).to eq('TRANSACTION_ID')
  end

  it 'raises if there is an error', :vcr do
    expect do
      subject.affiliates(affiliate_id: 'bloops')
    end.to raise_error(SoapyCake::RequestFailed)
  end

  it 'creates an affiliate and returns the ID', :vcr do
    result = subject.affiliate_signup(
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
      date_added: Date.today
    )

    expect(result).to eq(
      success: true,
      message: 'Affiliate Added Successfully',
      affiliate_id: 16173,
      tipalti_iframe_expiration_date: nil
    )
  end

  it 'returns media types', :vcr do
    result = subject.media_types

    expect(result.first).to eq(
      media_type_id: 15,
      type_name: 'Adware'
    )
  end

  context 'XML responses' do
    subject { described_class.new(xml_response: true) }

    it 'returns an XML string', :vcr do
      result = subject.media_types

      expect(result.next).to eq(File.read('spec/fixtures/raw_response.xml').strip)
    end
  end
end
