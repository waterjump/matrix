require 'rails_helper'

describe Parser::Sentinel do
  subject { Parser::Sentinel.new('sentinels') }

  let(:zion_format) do
    {
      source: nil,
      start_node: nil,
      end_node: nil,
      start_time: nil,
      end_time: nil
    }
  end

  let(:routes_file) { 'spec/fixtures/source_files/sentinels/routes.csv' }

  describe '#parse' do
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
