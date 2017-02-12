require 'rails_helper'

describe Sorter do
  subject { Sorter.new }

  before(:each) do
    params = { endpoint: URI.unescape(MatrixGateway.get_endpoint) }
    VCR.use_cassette('matrix', erb: params) do
      MatrixGateway.new.perform
    end
  end

  describe '#perform' do
    context 'when there are source files' do
      it 'returns success' do
        subject.perform
        expect(subject.success).to eq(true)
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
