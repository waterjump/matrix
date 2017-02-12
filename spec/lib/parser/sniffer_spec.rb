require 'rails_helper'

describe Parser::Sniffer do
  it_behaves_like 'a parser' do
    subject { Parser::Sniffer.new('sniffers') }
  end
end
