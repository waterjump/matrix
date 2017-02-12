class Parser::Loophole < Parser
  def initialize(source_name, files = nil)
    super
    @legs = []
  end

  def parse
    create_instance_variables('.json')
    return [] unless [@routes, @node_pairs].all?
    construct
    format_zion
  end

  private

  def construct
    @routes[:routes].each do |row|
      node_pair = join_hashes(row, @node_pairs[:node_pairs], :node_pair_id, :id)
      @legs << row.merge(node_pair.except(:id)) if node_pair.present?
    end
  end

  def format_zion
    @legs.each do |leg|
      @results <<
        {
          source: @source_name,
          start_node: leg[:start_node],
          end_node: leg[:end_node],
          start_time: format_time(leg[:start_time]),
          end_time: format_time(leg[:end_time])
        }
    end
  end

  def format_time(time)
    time.delete('Z')
  end
end
