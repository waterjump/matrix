class Sorter < Util

  def perform
    for_each_source do |src|
      parsed_data(src)
    end
    @success = @results.any?
  end

  private

  def for_each_source(&block)
    Rails.application.config.source_names.each do |src|
      yield(src)
    end
  end

  def parsed_data(src)
    return unless Dir.exist?(Rails.root.join('tmp', src))
    klass = "Parser::#{src.singularize.titleize}".constantize
    @results << klass.new(src).perform
  end
end
