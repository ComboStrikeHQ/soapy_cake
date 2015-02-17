RSpec.describe SoapyCake::Request do
  it 'raises if there is no api version stored' do
    expect do
      described_class.new(:test, :does, :not_exist).xml
    end.to raise_error(SoapyCake::Error, 'Unknown API call test::does::not_exist')
  end
end
