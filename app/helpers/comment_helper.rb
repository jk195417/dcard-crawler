module CommentHelper
  def bert_multi_sentences_encoder(text)
    raise "Can't encode \"\" or nil." if text.blank?

    result = text.gsub(URI::DEFAULT_PARSER.make_regexp, '').gsub(/\s*\n+\s*/, ' ||| ').gsub(/(\A\s\|\|\|\s|\s\|\|\|\s\z)/, '')
    raise 'After encode, result become "" or nil.' if result.blank?

    result
  end

  def url_to_img(text)
    text.gsub(URI::DEFAULT_PARSER.make_regexp) do |url|
      link_to url, target: '_blank' do
        url.match(/\.(jpeg|jpg|gif|png)$/) ? image_tag(url, style: 'max-height: 200px; max-width: 100%;') : url
      end
    end.html_safe
  end

  def gender_color(gender, opacity: 1)
    if gender == 'M'
      "rgba(102,212,253,#{opacity})"
    elsif gender == 'F'
      "rgba(255,129,173,#{opacity})"
    else
      "rgba(25,25,25,#{opacity})"
    end
  end

  def dcard_html(post_or_comment)
    "<div id=\"floor-#{post_or_comment&.floor}\"
          class=\"card mb-2\"
          style=\"background-color: #{gender_color(post_or_comment&.gender, opacity: 0.4)}\">
      <div class=\"card-body\">
        <div class=\"card-title\">
          <h5>#{post_or_comment&.school} #{post_or_comment&.department}</h5>
          <p class=\"text-muted\">B#{post_or_comment&.floor} #{time_formatter(post_or_comment&.created_at)}</p>
        </div>
        <div class=\"card-text\">
          #{url_to_img simple_format(post_or_comment&.content)}
        </div>
        <div class=\"card-text small text-muted\">
          <span>
            <i class=\"fas fa-heart\" style=\"color: rgb(254,69,78)\"></i>
            <i class=\"fas fa-times\"></i>
            #{post_or_comment&.like_count}
          </span>
          #{sentiment_span post_or_comment&.sentiment, klass: 'ml-2'}
        </div>
      </div>
    </div>".html_safe
  end
end
