class Parser::Sniffer < Parser

  def initialize(source_name, files = nil)
    super
    @legs = []
  end

  def parse
    create_instance_variables('.csv')
    return [] unless [@sequences, @node_times, @routes].all?
    construct
  end

  private

  def construct
    add_note_times
    add_route_times
    format_zion
  end

  def add_note_times
    @sequences.each do |seq|
      node_time = join_hashes(seq, @node_times, :node_time_id)
      @legs << seq.merge(node_time) if node_time.present?
    end
  end

  def add_route_times
    @legs.each do |leg|
      route = join_hashes(leg, @routes, :route_id)
      leg.merge!(route) if route.present?
    end
  end

  def format_zion
    route_ids(@legs).each do |id|
      route_rows = route_rows(id)
      start_time = start_time(
        route_rows.first[:time],
        route_rows.first[:time_zone]
      )
      current_time = start_time
      route_rows.each do |row|
        end_time =
          current_time + (row[:duration_in_milliseconds].to_i / 1000.0)
        @results <<
          {
            source: @source_name,
            start_node: row[:start_node],
            end_node: row[:end_node],
            start_time: current_time.utc.strftime('%FT%T'),
            end_time: end_time.utc.strftime('%FT%T')
          }
        current_time = end_time
      end
    end
  end

  def route_rows(id)
    @legs
      .select { |leg| leg[:route_id] == id }
      .sort_by { |leg| leg[:note_time_id] }
  end

  def start_time(time, zone)
    parts = time.gsub(/\-:T/, ',').split(',')
    offset = calculate_offset(zone)
    Time.new(parts[0],parts[1],parts[2],parts[3],parts[4],parts[5], offset)
  end

  def calculate_offset(offset)
    return 0 if offset == 'UTC±00:00'
    offset[-6, 6]
  end
end
