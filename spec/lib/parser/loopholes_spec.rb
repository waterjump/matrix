require 'rails_helper'

describe Parser::Loophole do
  it_behaves_like 'a parser' do
    subject { Parser::Loophole.new('loopholes') }
  end
end
