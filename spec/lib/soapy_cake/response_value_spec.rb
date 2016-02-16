# frozen_string_literal: true
RSpec.describe SoapyCake::ResponseValue do
  let(:time_converter) { double('date converter') }

  def parse(key, value)
    described_class.new(key, value, time_converter).parse
  end

  describe '#parse' do
    context 'booleans' do
      it 'converts the string "true" to the true value' do
        expect(parse(:foo, 'true')).to eq(true)
      end

      it 'converts the string "false" to the false value' do
        expect(parse(:foo, 'false')).to eq(false)
      end
    end

    context 'dates' do
      it 'delegates date-conversion to a TimeConverter instance' do
        expect(time_converter).to receive(:from_cake)
          .with('2014-06-30T01:00:00').and_return(:nice_date)

        expect(parse(:foo, '2014-06-30T01:00:00')).to eq(:nice_date)
      end
    end

    context 'strings' do
      it 'parses a string' do
        expect(parse(:foo, 'abc')).to eq('abc')
      end
    end

    context 'IDs' do
      it 'converts keys ending in "_id" to integers' do
        expect(parse(:conversion_id, '42')).to eq(42)
      end

      it "doesn't convert ids in the blacklist to integers" do
        expect(parse(:tax_id, '123abc')).to eq('123abc')
        expect(parse(:other_tax_id, '123abc')).to eq('123abc')
        expect(parse(:transaction_id, '123abc')).to eq('123abc')
      end

      it 'raises an error if not in the blacklist and non-digit characters are detected' do
        expect { parse(:foo_id, '123abc') }.to raise_error(SoapyCake::Error)
      end

      it 'does not raise an error if the value is absent' do
        expect(parse(:foo_id, '-1')).to eq(-1)
        expect(parse(:foo_id, '')).to eq(0)
        expect(parse(:foo_id, nil)).to eq(0)
      end
    end
  end
end
