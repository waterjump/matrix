class ZionEnvelope < Util
  class ValidationError < StandardError
  end

  attr_reader :errors

  def initialize(leg)
    @leg = leg
    @errors = []
  end

  def body
    if valid?
      return @leg
    else
      notify_error(ValidationError.new(@errors))
      return {}
    end
  end

  private

  def valid?
    valid_template.each_with_object([]) do |hash, memo|
      name = hash.first
      value = hash.last
      memo <<
        if value.is_a?(Array)
          validity = value.include?(@leg[name])
          errors << "#{name} is invalid: #{@leg[name]}" unless validity
          validity
        elsif value.is_a?(Regexp)
          validity = value === @leg[name]
          errors << "#{name} is invalid: #{@leg[name]}" unless validity
          validity
        end
      memo
    end.all?
  end

  def valid_template
    nodes = %w(alpha beta gamma delta theta lambda tau psi omega)
    time_regex = /\A\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\z/ # 'YYYY-MM-DDThh:mm:ss'
    {
      source: %w(sentinels sniffers loopholes),
      start_node: nodes,
      end_node: nodes,
      start_time: time_regex,
      end_time: time_regex
    }
  end
end
