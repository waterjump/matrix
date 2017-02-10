require 'rails_helper'

describe Parser::Sentinel do
  it_behaves_like 'a parser' do
    subject { Parser::Sentinel.new('sentinels') }
    let(:source_files) do
      Dir.glob('spec/fixtures/source_files/sentinels/*').entries
    end
  end
end
