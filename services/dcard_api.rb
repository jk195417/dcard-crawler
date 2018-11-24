class DcardAPI
  @@root = 'https://www.dcard.tw/_api'

  def self.forums
    @@root+'/forums'
  end

  def self.forum(name)
    @@root + "/forums/#{name}"
  end

  def self.forum(name)
    @@root + "/forums/#{name}"
  end

  def self.forum_posts(name)
    @@root + "/forums/#{name}/posts"
  end

  def self.posts(pid: nil)
    node = '/posts/'
    node += "/#{pid}" if pid
    @@root + node
  end

  def self.post_links(pid)
    @@root + "/posts/#{pid}/links"
  end

  def self.post_comments(pid)
    @@root + "/posts/#{pid}/comments"
  end
end
