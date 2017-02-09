require 'zip'

class MatrixGateway

  def self.endpoint
    "#{Rails.application.secrets.endpoint}?passphrase=#{Rails.application.secrets.passphrase}"
  end

  def initialize
    @success = true
  end

  def perform
    call
    unzip
    @success
  end

  private

  def call
    Rails.application.config.source_names.each do |src|
      File.open(file_name(src), 'w+') do |file|
        file.binmode
        resp = HTTParty.get("#{self.class.endpoint}&source=#{src}")
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

  def notify_error(error)
    @success = false
    raise error if Rails.env.development? || Rails.env.test?
    Rails.logger.info ("ERROR #{[error.message, error.backtrace]}")
  end
end
