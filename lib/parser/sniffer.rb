class Parser::Sniffer < Parser

  def initialize(source_name)
    super
    @legs = []
  end

  def parse
    create_instance_variables('.csv')
    construct
    @results
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
      start_time = Time.new(route_rows.first[:time]) # TODO include time_zone, format
      current_time = start_time
      route_rows.each do |row|
        end_time =
          current_time + (row[:duration_in_milliseconds].to_i / 1000.0)
        @results <<
          {
            source: @source_name,
            start_node: row[:start_node],
            end_node: row[:end_node],
            start_time: current_time,
            end_time: end_time
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
end
