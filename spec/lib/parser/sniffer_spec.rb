require 'rails_helper'

describe Parser::Sniffer do
  it_behaves_like 'a parser' do
    subject { Parser::Sniffer.new('sniffers') }
    let(:routes_file) { 'spec/fixtures/source_files/sniffers/routes.csv' }
  end
end
