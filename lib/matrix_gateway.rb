class MatrixGateway
  def self.endpoint
    "#{Rails.application.secrets.endpoint}?passphrase=#{Rails.application.secrets.passphrase}"
  end

  def initialize(source_name)
    @source_name = source_name
  end

  def call
    zip_from_source
    return true
  rescue StandardError => error
    Rails.logger.info(error.inspect)
    return false
  end

  private

  def zip_from_source
    File.delete(file_name)
    File.open(file_name, 'wb') do |file|
      file.binmode
      resp = HTTParty.get("#{self.class.endpoint}&source=#{@source_name}")
      file.write resp.parsed_response
      file.close
    end
  end

  def file_name
    file_name ||= "tmp/#{@source_name}.zip"
  end
end
