module GraphHelper
  def force_graph_node(post_or_comment)
    {
      id: "B#{post_or_comment.floor}",
      name: "B#{post_or_comment.floor}",
      floor: post_or_comment.floor,
      sentiment: post_or_comment.sentiment&.sentiment,
      confidence: post_or_comment.sentiment&.confidence,
      createdAt: post_or_comment.created_at.strftime("%s").to_i,
      valLike: Math.log(post_or_comment.like_count || 1) + 1,
      valLength: Math.log(post_or_comment.content&.size || 1) + 1,
      genderColor: gender_color(post_or_comment.gender),
      sentimentColor: sentiment_color(post_or_comment.sentiment&.sentiment, opacity: post_or_comment.sentiment&.confidence),
      html: dcard_html(post_or_comment)
    }
  end

  def force_graph_link(post_or_comment, target: 'B0')
    {
      source: "B#{post_or_comment.floor}",
      target: target,
      color: '#343a40'
    }
  end

  def force_graph_data_formater(post, comments)
    result = { nodes: [], links: [] }
    result[:nodes] << force_graph_node(post)
    comments.each { |comment| result[:nodes] << force_graph_node(comment) }
    comments.each do |comment|
      result[:links] << force_graph_link(comment) if comment.mentions.empty?
      comment.mentions.each do |mention|
        mention.upcase!
        node_index = result[:nodes].index { |node| node[:id] == mention }
        next unless node_index

        result[:links] << force_graph_link(comment, target: mention)
      end
    end
    result
  end
end
