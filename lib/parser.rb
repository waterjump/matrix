class Parser < Util

  class NotImplemented < StandardError
  end

  def initialize(source_name)
    super
    @source_name = source_name
    @results = []
  end

  def perform
    Dir[Rails.root.join('tmp', @source_name, '*')].entries.each do |file|
      @results << parse(file)
    end
    @results
  end

  def parse(*args)
    raise NotImplemented
  end

  private

  def workload(file)
    case file.split('.').last
    when 'csv'
      return csv_to_hash(file)
    else
      # TODO
    end
  end

  def csv_to_hash(file)
    CSV.read(
        file,
        headers: true,
        header_converters: :symbol,
        col_sep: ', ',
      ).map(&:to_h)
  end
end
