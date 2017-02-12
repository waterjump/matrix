class Parser < Util

  attr_reader :source_name

  def initialize(source_name, files = nil)
    super
    @source_name = source_name
    @files = files || Dir.glob(Rails.root.join('tmp', source_name, '*')).entries
  end

  def parse
    raise(NotImplementedError, "#{self.class} must implement the #parse method")
  end

  private

  def workload
    @files.map { |file| convert_to_hash(file) }
  end

  def convert_to_hash(file)
    case File.extname(file)
    when '.csv'
      return { file => csv_to_hash(file) }
    when '.json'
      return { file => JSON.parse(File.read(file)).with_indifferent_access }
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

  def create_instance_variables(extname)
    @files.each do |file_name|
      name = File.basename(file_name, extname)
      instance_variable_set(
        "@#{name}",
        workload.detect do |container|
          File.basename(container.keys.first, extname) == name
        end.values.first
      )
    end
  end

  def join_hashes(hash, ary, field_1, field_2 = nil)
    field_2 ||= field_1
     hash_to_merge =
      ary.detect do |hash_2|
        hash_2[field_2] == hash[field_1]
      end

    hash.merge(hash_to_merge.except(field_2)) if hash_to_merge.present?
  end
end
