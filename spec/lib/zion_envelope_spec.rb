require 'rails_helper'

describe ZionEnvelope do
  subject { ZionEnvelope }

  let(:good_parameters) do
    {
      source: 'sentinels',
      start_node: 'gamma',
      end_node: 'beta',
      start_time: '2030-12-31T08:55:32',
      end_time: '2030-12-31T08:58:17'
    }
  end

  let(:bad_parameters_1) do
    {
      source: 'sentinels',
      start_node: 'gamma',
      end_node: 'Springfield',
      start_time: '2030-12-31T08:55:32',
      end_time: '2030-12-31T08:58:17'
    }
  end

  let(:bad_parameters_2) do
    {
      source: 'sentinels',
      start_node: 'gamma',
      end_node: 'beta',
      start_time: '2030-12-31T08:55:32',
      end_time: '2030-12-31T13:00:05Z'
    }
  end

  before(:each) do
    params = { endpoint: URI.unescape(MatrixGateway.get_endpoint) }
    VCR.use_cassette('matrix', erb: params) do
      MatrixGateway.new.perform
    end
  end

  describe '#body' do
    context 'when data is valid' do
      it 'returns hash' do
        expect(subject.new(good_parameters).body).to eq(good_parameters)
      end
    end

    context 'when data is not valid' do
      it 'returns an empty hash' do
        expect(subject.new(bad_parameters_1).body).to eq({})
        expect(subject.new(bad_parameters_2).body).to eq({})
      end
    end
  end
end
