class Parser::Sentinel < Parser

  def parse(file)
    hash = workload(file)
    result = []
    route_ids = hash.map { |row| row[:route_id] }.uniq
    route_ids.each do |id|
      route_rows = route_rows(hash, id)
      (0..50).each do |index|
        next unless route_rows[index + 1].present?
        result <<
          {
            source: 'sentinels',
            start_node: route_rows[index][:node],
            end_node: route_rows[index + 1][:node],
            start_time: route_rows[index][:time], # TODO format
            end_time: route_rows[index + 1][:time] # TODO format
          }
      end
    end
    result
  end

  def route_rows(hash, id)
    hash
      .select { |row| row[:route_id] == id }
      .sort_by { |row| row[:index] }
  end
end
