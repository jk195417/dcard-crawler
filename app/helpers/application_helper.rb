module ApplicationHelper
  def bootstrap_alert_class(type)
    alert_class_for = {
      notice: 'success',
      alert: 'danger'
    }
    "alert-#{alert_class_for.fetch(type.to_sym, 'primary')}"
  end

  def bootstrap_alert(message, type = 'notice')
    icon = content_tag :i, '', class: 'fas fa-times'
    close_btn = content_tag :button, icon, class: 'close', 'data-dismiss': 'alert'
    content = message.to_s + close_btn
    content_tag(:div, content.html_safe, class: "alert #{bootstrap_alert_class(type)} alert-dismissible fade show").html_safe
  end

  def time_formatter(time)
    time.strftime('%Y-%m-%d %H:%M:%S')
  end

  def url_to_img(text)
    text.gsub(URI::DEFAULT_PARSER.make_regexp) do |url|
      if url.match(/\.(jpeg|jpg|gif|png)$/)
        "<a href=\"#{url}\" target=\"_blank\"><img src=\"#{url}\"/></a>"
      else
        "<a href=\"#{url}\">#{url}</a>"
      end
    end.html_safe
  end
end
