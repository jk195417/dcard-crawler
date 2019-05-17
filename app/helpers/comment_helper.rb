module CommentHelper
  def url_to_img(text)
    text.gsub(URI::DEFAULT_PARSER.make_regexp) do |url|
      link_to url, target: '_blank' do
        url.match(/\.(jpeg|jpg|gif|png)$/) ? image_tag(url, style: 'max-height: 200px; max-width: 100%;') : url
      end
    end.html_safe
  end
end
