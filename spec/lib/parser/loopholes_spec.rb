require 'rails_helper'

describe Parser::Loophole do
  it_behaves_like 'a parser' do
    subject { Parser::Loophole.new('loopholes') }
    let(:source_files) do
      Dir.glob('spec/fixtures/source_files/loopholes/*').entries
    end
  end
end
