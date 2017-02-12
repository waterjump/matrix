require 'rails_helper'

RSpec.describe 'Routes', type: :request do
  describe 'GET /routes' do

    let(:params) do
      {
        endpoint: URI.unescape(MatrixGateway.get_endpoint),
        passphrase: URI.unescape(Rails.application.secrets.passphrase)
      }
    end

    before(:each) do
      VCR.use_cassette('matrix', erb: params) do
        get routes_path
      end
    end

    let(:files) do
      Rails.application.config.source_names.map do |entry|
        "#{entry}.zip"
      end.sort
    end

    it 'works!' do
      VCR.use_cassette('matrix', erb: params) do
        expect(response).to be_success
        expect(response).to have_http_status(200)
        parsed_body = JSON.parse(response.body)
        expect(parsed_body).to be_kind_of(Hash)
        expect(parsed_body['status']).to eq('OK')
      end
    end

    it 'saves binary files' do
      expect((Dir.entries(Rails.root.join('tmp')) & files).sort).to eq(files)
    end

    it 'unzips binary files' do
      Rails.application.config.source_names.each do |src|
        expect(Dir.entries(Rails.root.join('tmp', src)).count).to be > 0
      end
    end
  end
end
