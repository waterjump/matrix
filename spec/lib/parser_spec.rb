require 'rails_helper'

describe Parser do
  subject { Parser.new('sentinels') }

  describe '#parse' do
    context 'is not overridden by child class' do
      it 'raises error' do
        expect(subject.perform).to raise_error(NotImplemented)
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
