# frozen_string_literal: true
RSpec.describe SoapyCake::ModificationTypeOptions do
  subject(:output_opts) do
    described_class.new(:foo, :foo_mod_type, 'bar').call(input_opts)
  end

  context 'no related params are provided' do
    let(:input_opts) { {} }

    it 'returns options for removing the set value' do
      expect(output_opts).to eq(foo: 'bar', foo_mod_type: 'remove')
    end
  end

  context 'a value is provided' do
    let(:input_opts) { { foo: 'ping' } }

    it 'returns options for changing the value' do
      expect(output_opts).to eq(foo: 'ping', foo_mod_type: 'change')
    end
  end

  context 'a modification type of "change" is provided' do
    let(:input_opts) { { foo_mod_type: 'change' } }

    it 'raises an error' do
      expect do
        output_opts
      end.to raise_error(
        SoapyCake::ModificationTypeOptions::InvalidInput,
        "`foo_mod_type` was 'change', but no `foo` was provided to change it to"
      )
    end
  end

  context 'a modification type of "remove" is provided' do
    let(:input_opts) { { foo_mod_type: 'remove' } }

    it 'returns options for removing the value' do
      expect(output_opts).to eq(foo: 'bar', foo_mod_type: 'remove')
    end
  end

  context 'a modification type of "do_not_change" is provided' do
    let(:input_opts) { { foo_mod_type: 'do_not_change' } }

    it 'returns options for not changing the value' do
      expect(output_opts).to eq(foo: 'bar', foo_mod_type: 'do_not_change')
    end
  end

  context 'a value and modification type are provided' do
    let(:input_opts) { { foo: 'ping', foo_mod_type: 'pong' } }

    it 'returns the options passed in' do
      expect(output_opts).to eq(foo: 'ping', foo_mod_type: 'pong')
    end
  end
end
