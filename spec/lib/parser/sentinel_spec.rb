require 'rails_helper'

describe Parser::Sentinel do
  it_behaves_like 'a parser' do
    subject { Parser::Sentinel.new('sentinels') }
    let(:routes_file) { 'spec/fixtures/source_files/sentinels/routes.csv' }
  end
end
