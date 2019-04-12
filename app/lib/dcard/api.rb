class Dcard::Api
  @@root = 'https://www.dcard.tw/_api'

  def self.forums
    "#{@@root}/forums"
  end

  def self.forum(name)
    "#{@@root}/forums/#{name}"
  end

  def self.forum_posts(name, limit: 100, popular: false, before: nil, after: nil)
    params = { limit: limit, popular: popular }
    params[:before] = before if before.present?
    params[:after] = after if after.present?
    "#{@@root}/forums/#{name}/posts?#{params.to_query}"
  end

  def self.posts(limit: 100, popular: false, before: nil)
    params = { limit: limit, popular: popular }
    params[:before] = before if before.present?
    "#{@@root}/posts/?#{params.to_query}"
  end

  def self.post(pid)
    "#{@@root}/posts/#{pid}"
  end

  def self.post_links(pid)
    "#{@@root}/posts/#{pid}/links"
  end

  def self.post_comments(pid, limit: 100, after: nil)
    params = { limit: limit }
    params[:after] = after if after.present?
    "#{@@root}/posts/#{pid}/comments?#{params.to_query}"
  end

  def self.search_posts(query, highlight: true, limit: 100, offset: 0, since: 0, forum: nil)
    params = {
      query: query,
      highlight: highlight,
      limit: limit,
      offset: offset,
      since: since
    }
    params[:forum] = forum if forum.present?
    "#{@@root}/search/posts?#{params.to_query}"
  end
end
