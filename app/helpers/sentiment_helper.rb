module SentimentHelper
  def sentiment_color(text, opacity: 1)
    text = text.to_s
    if text == 'negative'
      "rgba(220,53,69,#{opacity})"
    elsif text == 'neutral'
      "rgba(40,167,69,#{opacity})"
    elsif text == 'positive'
      "rgba(0,123,255,#{opacity})"
    else
      "rgba(108,117,125,#{opacity})"
    end
  end

  def sentiment_span(sentiment, klass: '')
    content_tag :span, class: klass do
      doms = []
      doms << content_tag(:span, sentiment&.sentiment, style: "color: #{sentiment_color(sentiment&.sentiment)};")
      doms << content_tag(:span, "confidence: #{sentiment&.confidence}", class: 'ml-1')
      doms.join('').html_safe
    end
  end
end
