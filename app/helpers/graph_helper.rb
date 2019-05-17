module GraphHelper
  def force_graph_data_formater(post, comments)
    result = {
      nodes: [
        {
          id: 'B0',
          name: 'B0',
          val: 1,
          val_like: Math.log(post.like_count || 1) + 1,
          val_content: Math.log(post.content&.size || 1) + 1,
          color: gender_color(post.gender),
          html: node_html(post)
        }
      ],
      links: []
    }
    comments.each do |comment|
      result[:nodes] << {
        id: "B#{comment.floor}",
        name: "B#{comment.floor}",
        val: 1,
        val_like: Math.log(comment.like_count || 1) + 1,
        val_content: Math.log(comment.content&.size || 1) + 1,
        color: gender_color(comment.gender),
        html: node_html(comment)
      }
    end
    comments.each do |comment|
      if comment.mentions.empty?
        result[:links] << {
          source: "B#{comment.floor}",
          target: 'B0',
          color: '#343a40'
        }
      else
        comment.mentions.each do |mention|
          node_index = result[:nodes].index { |node| node[:id] == mention }
          next unless node_index

          result[:links] << {
            source: "B#{comment.floor}",
            target: mention,
            color: '#343a40'
          }
        end
      end
    end
    result
  end
end
