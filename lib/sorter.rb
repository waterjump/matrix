class Sorter

  def initialize
    @success = true
  end

  def perform
    success =
      Rails.application.config.source_names.each_with_object([]) do |src, results|
        next unless Dir.exist?(Rails.root.join('tmp',src))
        Dir.foreach(Rails.root.join('tmp',src)) do
          # send to parser
          results << true
        end
    end
    @success = success.any?
  end

  def notify_error(error)
    @success = false
    raise error if Rails.env.development? || Rails.env.test?
    Rails.logger.info ("ERROR #{[error.message, error.backtrace]}")
  end
end
