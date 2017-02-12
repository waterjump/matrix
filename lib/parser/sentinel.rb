class Parser::Sentinel < Parser

  def parse
    return [] unless workload.present?
    workload.each do |container|
      container.values.each do |hash|
        route_ids(hash).each do |id|
          route_rows = route_rows(hash, id)
          (0..50).each do |index|
            next unless route_rows[index + 1].present?
            @results << zion_format(route_rows, index)
          end
        end
      end
    end
  end

  private

  def route_rows(hash, id)
    hash
      .select { |row| row[:route_id] == id }
      .sort_by { |row| row[:index] }
  end

  def zion_format(route_rows, index)
    {
      source: @source_name,
      start_node: route_rows[index][:node],
      end_node: route_rows[index + 1][:node],
      start_time: format_time(route_rows[index][:time]),
      end_time: format_time(route_rows[index + 1][:time])
    }
  end

  def format_time(time) # TODO do this the better way
    year = time[0, 4]
    month = time[5, 2]
    day = time[8, 2]
    hour = time[11, 2]
    minute = time[14, 2]
    second = time[17, 2]
    offset = time[19, 6]
    Time.new(year, month, day, hour, minute, second, offset)
      .utc
      .strftime('%FT%T')
  end
end
