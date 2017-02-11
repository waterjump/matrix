require 'rails_helper'

describe ZionEnvelope do
  subject { ZionEnvelope.new }

  before(:each) do
    params = { endpoint: URI.unescape(MatrixGateway.endpoint) }
    VCR.use_cassette('matrix', erb: params) do
      MatrixGateway.new.perform
    end
  end

  describe '#body' do
    context 'when data is valid' do
      it 'returns hash' do
        expect(subject.body).to eq(true)
      end
    end

    context 'when data is not valid' do
      it 'returns an empty hash' do
        expect(subject.body).to eq({})
      end
    end
  end
end
