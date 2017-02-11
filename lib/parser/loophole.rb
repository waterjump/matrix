class Parser::Loophole < Parser

  def initialize(source_name)
    super
    @legs = []
  end

  def parse
    create_instance_variables('.json')
    construct
    format_zion
    @results
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
          start_time: leg[:start_time], # TODO format
          end_time: leg[:end_time]
        }
    end
  end
end
