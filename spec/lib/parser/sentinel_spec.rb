require 'rails_helper'

describe Parser::Sentinel do
  it_behaves_like 'a parser' do
    subject { Parser::Sentinel.new('sentinels') }
  end
end
