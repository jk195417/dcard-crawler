class Dcard::Api
  @@root = 'https://www.dcard.tw/_api'

  def self.forums
    "#{@@root}/forums"
  end

  def self.forum(name)
    "#{@@root}/forums/#{name}"
  end

  def self.forum_posts(name, before: nil, after: nil, popular: false)
    link = "#{@@root}/forums/#{name}/posts?limit=100&popular=#{popular}"
    link += "&before=#{before}" unless before.nil?
    link += "&after=#{after}" unless after.nil?
    link
  end

  def self.posts(before: nil, popular: false)
    link = "#{@@root}/posts/?limit=100&popular=#{popular}"
    link += "&before=#{before}" unless before.nil?
    link
  end

  def self.post(pid)
    "#{@@root}/posts/#{pid}"
  end

  def self.post_links(pid)
    "#{@@root}/posts/#{pid}/links"
  end

  def self.post_comments(pid, after: nil)
    link = "#{@@root}/posts/#{pid}/comments?limit=100"
    link += "&after=#{after}" unless after.nil?
    link
  end
end
