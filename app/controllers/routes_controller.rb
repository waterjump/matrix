class RoutesController < ApplicationController

  def parse
    sources = %w(sentinels sniffers loopholes)
    sources.each do |src|
      file_name = "tmp/#{src}.zip"
      File.delete(file_name)
      File.open(file_name, 'wb') do |file|
        file.binmode
        resp = HTTParty.get("#{Rails.application.secrets.endpoint}?passphrase=#{Rails.application.secrets.passphrase}&source=#{src}")
        file.write resp.parsed_response
        file.close
      end
    end
    render json: { status: 'Success' }
  end
end
