class Util
  class NotImplemented < StandardError
  end

  def initialize(*args)
    @success = true
  end

  def perform
    raise NotImplemented
  end

  private

  def notify_error(error)
    @success = false
    raise error if Rails.env.development? || Rails.env.test?
    Rails.logger.info ("ERROR #{[error.message, error.backtrace]}")
  end
end
