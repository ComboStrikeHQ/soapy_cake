# frozen_string_literal: true

RSpec.describe SoapyCake::Response do
  let(:xml) do
    <<-XML
      <?xml version="1.0" encoding="utf-8"?>
      <soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope">
        <soap:Body>
          <SomeResponse>
            <SomeResult>
              <success>true</success>
              <row_count>2</row_count>
              <somes>
                <some>
                  <id>123</id>
                </some>
                <some>
                  <id>312</id>
                </some>
              </somes>
            </SomeResult>
          </SomeResponse>
        </soap:Body>
      </soap:Envelope>
    XML
  end

  subject(:response) { described_class.new(xml.strip, false, 0) }

  it 'returns an enumerator' do
    expect(response.to_enum).to be_a(Enumerator)
  end

  it 'parses the CAKE XML structure properly' do
    expect(response.to_enum.to_a).to eq([{ id: '123' }, { id: '312' }])
  end
end
