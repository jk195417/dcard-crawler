# Usage :
# Dcard::API.forums
# Dcard::API.forum('3c')
# Dcard::API.posts
# Dcard::API.post(dcard_id)
# Dcard::API.post_links(dcard_id)
# Dcard::API.post_comments(dcard_id)
# Dcard::API.search_posts(query: '組裝', forum: '3c', highlight: false
#
# Returm a url String

class Dcard::API
  @@host = 'https://www.dcard.tw/_api'

  def self.forums
    "#{@@host}/forums"
  end

  def self.forum(name)
    "#{@@host}/forums/#{name}"
  end

  def self.posts(forum: nil, **options)
    if forum
      "#{@@host}/forums/#{forum}/posts?#{options_query(options)}"
    else
      "#{@@host}/posts/?#{options_query(options)}"
    end
  end

  def self.post(dcard_id)
    "#{@@host}/posts/#{dcard_id}"
  end

  def self.post_links(dcard_id)
    "#{@@host}/posts/#{dcard_id}/links"
  end

  def self.post_comments(dcard_id, **options)
    "#{@@host}/posts/#{dcard_id}/comments?#{options_query(options)}"
  end

  def self.search_posts(**options)
    "#{@@host}/search/posts?#{options_query(options)}"
  end

  private

  def self.options_query(**options)
    params = {
      limit: options.fetch(:limit) { 100 },
      popular: options.fetch(:popular) { nil },
      before: options.fetch(:before) { nil },
      after: options.fetch(:after) { nil },
      forum: options.fetch(:forum) { nil },
      query: options.fetch(:query) { nil },
      highlight: options.fetch(:highlight) { nil },
      offset: options.fetch(:offset) { nil },
      since: options.fetch(:since) { nil }
    }
    params.reject! { |_key, value| value.nil? }
    params.to_query
  end
end
