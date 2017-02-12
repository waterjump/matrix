class Util
  class NotImplementedError < StandardError
  end

  attr_reader :results, :success

  def initialize(*_args)
    @success = true
    @results = []
  end

  def perform
    raise(NotImplementedError, "#{self.class} must implement the #perform method")
  end

  private

  def notify_error(error, _message = '')
    @success = false
    raise(error) if Rails.env.development?
    Rails.logger.info "ERROR #{[error.message, error.backtrace]}"
  end
end
