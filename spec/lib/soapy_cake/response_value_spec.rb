RSpec.describe SoapyCake::ResponseValue do
  def subject(*args)
    described_class.new(*args)
  end

  describe '#parse' do
    context 'booleans' do
      it 'converts the string "true" to the true value' do
        expect(subject(:foo, 'true').parse).to eq(true)
      end

      it 'converts the string "false" to the false value' do
        expect(subject(:foo, 'false').parse).to eq(false)
      end
    end

    context 'dates' do
      it 'parses an ISO-formatted date' do
        expect(subject(:foo, '2014-06-30T01:00:00').parse).to eq(DateTime.new(2014, 6, 30, 1))
      end

      it 'properly applies the provided time offset' do
        expect(subject(:foo, '2014-01-01T00:00:00', time_offset: 5).parse)
          .to eq(DateTime.new(2014, 1, 1, 0).change(offset: '+0500'))

        expect(subject(:foo, '2014-12-31T01:00:00', time_offset: -2).parse)
          .to eq(DateTime.new(2014, 12, 31, 1).change(offset: '-0200'))
      end
    end

    context 'strings' do
      it 'parses a string' do
        expect(subject(:foo, 'abc').parse).to eq('abc')
      end
    end

    context 'IDs' do
      it 'converts keys ending in "_id" to integers' do
        expect(subject(:conversion_id, '42').parse).to eq(42)
      end

      it "doesn't convert ids in the blacklist to integers" do
        expect(subject(:tax_id, '123abc').parse).to eq('123abc')
        expect(subject(:other_tax_id, '123abc').parse).to eq('123abc')
        expect(subject(:transaction_id, '123abc').parse).to eq('123abc')
      end

      it 'raises an error if not in the blacklist and non-digit characters are detected' do
        expect { subject(:foo_id, '123abc').parse }.to raise_error(SoapyCake::Error)
      end

      it 'does not raise an error if the value is absent' do
        expect(subject(:foo_id, '-1').parse).to eq(-1)
        expect(subject(:foo_id, '').parse).to eq(0)
        expect(subject(:foo_id, nil).parse).to eq(0)
      end
    end
  end
end
