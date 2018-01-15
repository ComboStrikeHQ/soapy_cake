# frozen_string_literal: true

# rubocop:disable Style/DateTime
RSpec.describe SoapyCake::TimeConverter do
  subject(:time_converter) { described_class.new('Europe/Berlin') }

  describe '#to_cake' do
    it 'converts a time-like object into a cake timestamp' do
      expect(time_converter.to_cake(DateTime.new(2015, 1, 2, 12, 30))).to eq('2015-01-02T13:30:00')
      expect(time_converter.to_cake(Time.utc(2015, 1, 2, 12, 30))).to eq('2015-01-02T13:30:00')
      expect(time_converter.to_cake(Date.new(2015, 1, 2))).to eq('2015-01-02T01:00:00')
    end

    it 'respects DST' do
      expect(time_converter.to_cake(Time.utc(2015, 1, 2, 12, 30))).to eq('2015-01-02T13:30:00')
      expect(time_converter.to_cake(Time.utc(2015, 6, 2, 12, 30))).to eq('2015-06-02T14:30:00')
    end
  end

  describe '#from_cake' do
    it 'parses cake dates into the specified time zone (including DST)' do
      expect(time_converter.from_cake('2015-01-11T14:53:40.000')).to be_a(Time)
      expect(time_converter.from_cake('2015-01-11T14:53:40.000'))
        .to eq(Time.utc(2015, 1, 11, 13, 53, 40))
      expect(time_converter.from_cake('2015-06-11T14:53:40.000'))
        .to eq(Time.utc(2015, 6, 11, 12, 53, 40))
    end
  end

  context 'legacy mode / CAKE_TIME_OFFSET' do
    subject(:time_converter) { described_class.new('Europe/Berlin', 5) }

    it 'works as before (broken, without DST)' do
      expect(STDERR).to receive(:puts).with(/Please use time_zone/)

      expect(time_converter.to_cake(DateTime.new(2015, 1, 2, 12, 30))).to eq('2015-01-02T17:30:00')
      expect(time_converter.to_cake(DateTime.new(2015, 6, 2, 12, 30))).to eq('2015-06-02T17:30:00')
    end
  end
end
# rubocop:enable Style/DateTime
