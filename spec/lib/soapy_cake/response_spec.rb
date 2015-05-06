RSpec.describe SoapyCake::Response do
  subject { described_class.new('', '') }

  describe '#parse_element' do
    it 'converts keys ending in "_id" to integers' do
      expect(subject.send(:parse_element, :conversion_id, '42')).to eq(42)
    end

    it "doesn't convert ids in the blacklist to integers" do
      expect(subject.send(:parse_element, :tax_id, '123abc')).to eq('123abc')
      expect(subject.send(:parse_element, :other_tax_id, '123abc')).to eq('123abc')
      expect(subject.send(:parse_element, :transaction_id, '123abc')).to eq('123abc')
    end
  end
end
