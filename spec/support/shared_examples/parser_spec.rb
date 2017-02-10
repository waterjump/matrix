require 'rails_helper'

RSpec.shared_examples 'a parser' do

  let(:zion_format) do
    {
      source: nil,
      start_node: nil,
      end_node: nil,
      start_time: nil,
      end_time: nil
    }
  end

  describe '#parse' do
    context 'when there are no source files' do
      it 'returns empty set' do
        FileUtils.rm_rf(Dir.glob('tmp/*'))
        expect(subject.perform).to eq([])
      end

      it 'returns a an array' do
        expect(subject.parse(routes_file)).to be_kind_of(Array)
      end

      it 'returns and array of hashes' do
        expect(subject.parse(routes_file).first).to be_kind_of(Hash)
      end

      it 'hashes in Zion format' do
        expect(subject.parse(routes_file).first.keys).to eq(zion_format.keys)
      end
    end
  end
end
