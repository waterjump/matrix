require 'rails_helper'

RSpec.describe 'Routes', type: :request do
  describe 'GET /routes' do
    it 'works!' do
      get routes_path
      expect(response).to be_success
      expect(response).to have_http_status(200)
      parsed_body = JSON.parse(response.body)
      expect(parsed_body).to be_kind_of(Hash)
      expect(parsed_body['status']).to eq('Success')
    end
  end
end
