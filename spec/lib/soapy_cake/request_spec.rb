RSpec.describe SoapyCake::Request do
  it 'raises if there is no api version stored' do
    expect do
      described_class.new(:test, :does, :not_exist).xml
    end.to raise_error(SoapyCake::Error, 'Unknown API call test::does::not_exist')
  end

  it 'raises when you pass non-date-like objects in date fields' do
    expect do
      described_class.new(:admin, :export, :offers, start_date: '2015-01-01').xml
    end.to raise_error(SoapyCake::Error, /Date object for 'start_date'/)
  end
end
