require 'rails_helper'

describe Parser::Sniffer do
  it_behaves_like 'a parser' do
    subject { Parser::Sniffer.new('sniffers') }
    let(:source_files) do
      Dir.glob('spec/fixtures/source_files/sniffers/*').entries
    end
  end
end
