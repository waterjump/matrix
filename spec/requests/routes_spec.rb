require 'rails_helper'

RSpec.describe 'Routes', type: :request do
  describe 'GET /routes' do

    before(:each) { get routes_path }

    let(:files) do
      %w(sentinels sniffers loopholes).map do |entry|
        "#{entry}.zip"
      end.sort
    end

    it 'works!' do
      expect(response).to be_success
      expect(response).to have_http_status(200)
      parsed_body = JSON.parse(response.body)
      expect(parsed_body).to be_kind_of(Hash)
      expect(parsed_body['status']).to eq('Success')
    end

    it 'saves binary files' do
      expect((Dir.entries(Rails.root.join('tmp')) & files).sort).to eq(files)
    end
  end
end
