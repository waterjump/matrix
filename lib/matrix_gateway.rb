require 'zip'

class MatrixGateway
  def self.endpoint
    "#{Rails.application.secrets.endpoint}?passphrase=#{Rails.application.secrets.passphrase}"
  end

  def initialize(source_name)
    @source_name = source_name
  end

  def call
    zip_from_source
    unzip
    return true
  rescue StandardError => error
    if Rails.env.development?
      raise error
    else
      Rails.logger.info(error.message)
      return false
    end
  end

  private

  def zip_from_source
    File.delete(file_name) if File.exist?(file_name)
    File.open(file_name, 'wb') do |file|
      file.binmode
      resp = HTTParty.get("#{self.class.endpoint}&source=#{@source_name}")
      file.write resp.parsed_response
      file.close
    end
  end

  def unzip
    Zip.on_exists_proc = true
    Rails.application.config.source_names.each do |src|
      Dir.mkdir("tmp/#{src}") unless File.exist?("tmp/#{src}")
      Zip::File.open("tmp/#{src}.zip") do |zip_file|
        zip_file.each do |entry|
          entry.extract("tmp/#{entry.name}")
        end
      end
    end
  end

  def file_name
    file_name ||= "tmp/#{@source_name}.zip"
  end
end
