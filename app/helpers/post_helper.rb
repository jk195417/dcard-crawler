# frozen_string_literal: true

module PostHelper
  def gender_color(gender)
    if gender == 'M'
      'rgba(102,212,253,0.4)'
    elsif gender == 'F'
      'rgba(255,129,173,0.4)'
    else
      'rgba(25,25,25,0.4)'
    end
  end

  def sigmajs_data_formater(post, comments)
    result = {
      nodes: [
        {
          id: 'B0',
          label: 'B0',
          x: 0,
          y: 0,
          size: 5 + post.mentions.size,
          color: gender_color(post.gender)
        }
      ],
      edges: []
    }
    comments.each do |comment|
      result[:nodes] << {
        id: "B#{comment.floor}",
        label: "B#{comment.floor}",
        x: rand(-100..100),
        y: rand(-20..20),
        size: 1 + comment.mentions.size,
        color: gender_color(comment.gender)
      }
      if comment.mentions.empty?
        result[:edges] << {
          id: "B#{comment.floor}_to_B0",
          source: "B#{comment.floor}",
          target: 'B0'
        }
      else
        comment.mentions.each.with_index do |mention, index|
          result[:edges] << {
            id: "B#{comment.floor}[#{index}]_to_#{mention}",
            source: "B#{comment.floor}",
            target: mention
          }
        end
      end
    end
    comments.each do |comment|
      comment.mentions.each.with_index do |mention, _index|
        node_index = result[:nodes].index { |node| node[:id] == mention }
        result[:nodes][node_index][:size] += 1
      end
    end
    result
  end
end
