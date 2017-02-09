require 'rails_helper'

describe Sorter do
  subject { Sorter.new }

  before(:each) do
    params = { endpoint: URI.unescape(MatrixGateway.endpoint) }
    VCR.use_cassette('matrix', erb: params) do
      MatrixGateway.new.perform
    end
  end

  describe '#perform' do
    context 'when there are source files' do
      it 'returns success' do
        expect(subject.perform).to eq(true)
      end
    end

    context 'when there are no source files' do
      it 'returns failure' do
        FileUtils.rm_rf(Dir.glob('tmp/*'))
        expect(subject.perform).to eq(false)
      end
    end
  end
end
