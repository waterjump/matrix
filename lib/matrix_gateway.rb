require 'zip'

class MatrixGateway < Util

  def self.get_endpoint
    "#{Rails.application.secrets.endpoint}?passphrase=#{Rails.application.secrets.passphrase}"
  end

  def self.post_endpoint
    Rails.application.secrets.endpoint
  end

  def perform
    call
    unzip
    @success
  end

  def send(workload)
    envelopes = []
    workload.each do |leg|
      envelopes << ZionEnvelope.new(leg).body
    end
    envelopes.each do |env|
      body =
        env
          .reverse_merge(
            passphrase: URI.unescape(Rails.application.secrets.passphrase)
          )
          .to_json
      resp =
        HTTParty.post(
          self.class.post_endpoint,
          body: body,
          headers: { 'Content-Type' => 'application/json' }
          )
      if resp.response.code != '201'
        Rails.logger.info "Issue sending envelope to Zion: #{env} | #{resp}"
      end
    end
  rescue StandardError => error
    notify_error(error)
  end

  private

  def call
    Rails.application.config.source_names.each do |src|
      File.open(file_name(src), 'w+') do |file|
        file.binmode
        resp = HTTParty.get("#{self.class.get_endpoint}&source=#{src}")
        file.write resp.parsed_response
        file.close
      end
    end
  rescue StandardError => error
    notify_error(error)
  end

  def unzip
    Zip.on_exists_proc = true
    Rails.application.config.source_names.each do |src|
      Zip::File.open(file_name(src)) do |zip_file|
        zip_file.each do |entry|
          entry.extract("tmp/#{entry.name}")
        end
      end
    end
  rescue StandardError => error
    notify_error(error)
  end

  def file_name(src)
    file_name ||= "tmp/#{src}.zip"
  end
end
