class Parser::Sniffer < Parser

  def initialize(source_name)
    super
    @legs = []
  end

  def parse
    create_instance_variables
    construct
    @results
  end

  private

  def create_instance_variables
    @files.each do |file_name|
      name = file_name.split('/').last.split('.').first # TODO File#basename
      instance_variable_set(
        "@#{name}",
        workload.detect do |container|
          container.keys.first =~ /#{name}/
        end.values.first
      )
    end
  end

  def construct
    add_note_times
    add_route_times
    format_zion
  end

  def add_note_times
    @sequences.each do |seq|
      node_time =
        @node_times.detect do |nt|
          nt[:node_time_id] == seq[:node_time_id]
        end

      @legs << seq.merge(node_time) if node_time.present?
    end
  end

  def add_route_times
    @legs.each do |leg|
      route = @routes.detect do |rt|
        rt[:route_id] == leg[:route_id]
      end

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
