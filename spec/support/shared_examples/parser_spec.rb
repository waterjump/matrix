require 'rails_helper'

RSpec.shared_examples 'a parser' do
  let(:params) do
    {
      endpoint: URI.unescape(MatrixGateway.get_endpoint),
      passphrase: URI.unescape(Rails.application.secrets.passphrase)
    }
  end

  let(:zion_format) do
    {
      source: nil,
      start_node: nil,
      end_node: nil,
      start_time: nil,
      end_time: nil
    }
  end

  before(:each) do
    VCR.use_cassette('matrix', erb: params) do
      MatrixGateway.new.perform
    end
  end

  describe '#parse' do
    context 'when there are no source files' do
      it 'returns empty set' do
        parser =
          subject.class.new(
            subject.source_name,
            Dir.glob(Rails.root.join('spec/fixtures/empty_directory/*'))
              .entries
          )
        parser.parse
        expect(parser.results).to eq([])
      end

      it 'returns a an array' do
        subject.parse
        expect(subject.results).to be_kind_of(Array)
      end

      it 'returns and array of hashes' do
        subject.parse
        expect(subject.results.first).to be_kind_of(Hash)
      end

      it 'hashes in Zion format' do
        subject.parse
        expect(subject.results.first.keys).to eq(zion_format.keys)
      end
    end
  end
end
