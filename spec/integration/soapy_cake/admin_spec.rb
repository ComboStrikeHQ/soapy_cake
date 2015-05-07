RSpec.describe SoapyCake::Admin do
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
      # dates
      date_created: DateTime.new(2014, 4, 28, 10, 52, 15.537),
      # floats
      minimum_payment_threshold: '0.0000'
    )

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
end
