# frozen_string_literal: true

module GraphHelper
  def gender_color(gender, opacity: 1)
    if gender == 'M'
      "rgba(102,212,253,#{opacity})"
    elsif gender == 'F'
      "rgba(255,129,173,#{opacity})"
    else
      "rgba(25,25,25,#{opacity})"
    end
  end

  def node_html(post_or_comment)
    "<div id=\"floor-#{post_or_comment.floor}\"
          class=\"card\"
          style=\"background-color: #{gender_color(post_or_comment.gender, opacity: 0.4)}\">
      <div class=\"card-body\">
        <div class=\"card-title\">
          <h5>#{post_or_comment.school} #{post_or_comment.department}</h5>
          <p class=\"text-muted\">B#{post_or_comment.floor} #{time_formatter(post_or_comment.created_at)}</p>
        </div>
        <div class=\"card-text\">
          #{url_to_img(simple_format(post_or_comment.content))}
        </div>
        <div class=\"card-text small text-muted\">
          <i class=\"fas fa-heart\" style=\"color: rgb(254,69,78)\"></i>
          <i class=\"fas fa-times\"></i>
          #{post_or_comment.like_count}
        </div>
      </div>
    </div>"
  end

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
