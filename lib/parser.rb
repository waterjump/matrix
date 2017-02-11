class Parser < Util

  class NotImplemented < StandardError
  end

  def initialize(source_name)
    super
    @source_name = source_name
    @files = Dir.glob(Rails.root.join('tmp', source_name, '*')).entries
  end

  def perform
    @results << parse
  end

  def parse
    raise NotImplemented
  end

  private

  def workload
    @files.map { |file| convert_to_hash(file) }
  end

  def convert_to_hash(file)
    case file.split('.').last
    when 'csv'
      return { file => csv_to_hash(file) }
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

  def route_ids(hash)
    hash.map { |row| row[:route_id] }.uniq
  end
end
